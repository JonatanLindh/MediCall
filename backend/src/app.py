from http.client import OK, UNAUTHORIZED
import json
from bcrypt import gensalt, hashpw
import bcrypt
from prisma import Base64, Prisma
from prisma.models import Doctor, Patient
from robyn import Response, Robyn, WebSocket
from robyn.types import Body

app = Robyn(__file__)
websocket = WebSocket(app, "/ws")
prisma = Prisma(auto_register=True)


@app.startup_handler
async def startup_handler() -> None:
    await prisma.connect()


@app.shutdown_handler
async def shutdown_handler() -> None:
    if prisma.is_connected():
        await prisma.disconnect()


class RegisterBody(Body):
    firstName: str
    lastName: str
    email: str
    password: str


@app.post("/api/doctors")
async def register_doctor(request, body: RegisterBody):
    data = request.json()

    password = data["password"]
    first_name = data["firstName"]
    last_name = data["lastName"]
    email = data["email"]

    pass_hash = hashpw(password.encode("utf-8"), gensalt())

    await Doctor.prisma().create(
        data={
            "firstName": first_name,
            "lastName": last_name,
            "email": email,
            "password_hash": Base64.encode(pass_hash),
        },
    )


@app.post("/api/patients/register")
async def register_patient(request, body: RegisterBody):
    data = request.json()
    first_name = data["firstName"]
    last_name = data["lastName"]
    email = data["email"]
    password = data["password"]

    pass_hash = hashpw(password.encode("utf-8"), gensalt())

    await Patient.prisma().create(
        data={
            "firstName": first_name,
            "lastName": last_name,
            "email": email,
            "password_hash": Base64.encode(pass_hash),
        },
    )

    return Response(
        status_code=201,
        headers={},
        description="Patient registered successfully",
    )


class UpdateDoctorLocationBody(Body):
    latitude: float
    longitude: float


# TODO add auth
@app.patch("/api/doctors/:id/location")
async def update_doctor_location(request, body: UpdateDoctorLocationBody):
    id = request.path_params["id"]
    data = request.json()
    latitude = data["latitude"]
    longitude = data["longitude"]

    print(f"Updating doctor {id} location to {latitude}, {longitude}")

    await Doctor.prisma().update(
        where={"id": id},
        data={
            "latitude": float(latitude),
            "longitude": float(longitude),
        },
    )


# TODO add auth
@app.get("/api/doctors/:id/location")
async def get_doctor_location(request):
    id = request.path_params["id"]
    doctor = await Doctor.prisma().find_unique(
        where={"id": id},
    )
    if doctor:
        return json.dumps(
            {
                "latitude": doctor.latitude,
                "longitude": doctor.longitude,
            },
            indent=2,
        )
    else:
        return Response(status_code=404, description="Doctor not found", headers={})


class LoginBody(Body):
    email: str
    password: str


@app.post("/api/patients/login")
async def login(request, body: LoginBody):
    data = request.json()
    email = data.get("email")
    password = data.get("password")

    user = await Patient.prisma().find_first(
        where={"email": email},
    )

    if user and bcrypt.checkpw(
        password.encode("utf-8"), Base64.decode(user.password_hash)
    ):
        print(f"User {user.id} logged in")
        return Response(status_code=OK, headers={}, description="OK")

    print("Invalid credentials")
    return Response(status_code=UNAUTHORIZED, headers={}, description="Unauthorized")


if __name__ == "__main__":
    app.start(host="0.0.0.0", port=8080)
