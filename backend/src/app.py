from http.client import OK, UNAUTHORIZED
import json
from bcrypt import gensalt, hashpw
from prisma import Base64, Prisma
from prisma.models import Doctor
from robyn import Response, Robyn
from robyn.types import Body

app = Robyn(__file__)
prisma = Prisma(auto_register=True)


@app.startup_handler
async def startup_handler() -> None:
    await prisma.connect()


@app.shutdown_handler
async def shutdown_handler() -> None:
    if prisma.is_connected():
        await prisma.disconnect()


class CreateDoctorBody(Body):
    firstName: str
    lastName: str
    email: str
    password: str


@app.post("/api/doctors")
async def register_doctor(request, body: CreateDoctorBody):
    data = request.json()

    password = data["password"]
    first_name = data["firstName"]
    last_name = data["lastName"]
    email = data["email"]

    pass_hash = hashpw(password.encode("utf-8"), gensalt())

    doctor = await Doctor.prisma().create(
        data={
            "firstName": first_name,
            "lastName": last_name,
            "email": email,
            "password_hash": Base64.encode(pass_hash),
        },
    )
    return doctor.model_dump_json(indent=2)


class UpdateDoctorLocationBody(Body):
    latitude: float
    longitude: float


# TODO add auth
@app.patch("/api/doctors/:id/location")
async def update_doctor_location(request, body: UpdateDoctorLocationBody):
    print("hej")
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


# user list
users = {
    "test@example.com": "password123",
    "admin@example.com": "adminpass",
}


@app.post("/api/login")
async def login(request):
    data = request.json()
    email = data.get("email")
    password = data.get("password")

    if email in users and users[email] == password:
        print("Login success")
        return Response(status_code=OK, headers={}, description="OK")
    else:
        print("Login failed")
        return Response(
            status_code=UNAUTHORIZED, headers={}, description="Unauthorized"
        )


if __name__ == "__main__":
    app.start(host="0.0.0.0", port=8080)
