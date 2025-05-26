from http.client import OK, UNAUTHORIZED
import json
from bcrypt import gensalt, hashpw
import bcrypt
from prisma import Base64, Prisma
from prisma.models import Doctor, Patient
from prisma.bases import BaseDoctor
from robyn import Response, Robyn, WebSocket, jsonify
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


@app.post("/api/doctors/register")
async def register_doctor(request, body: RegisterBody):
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

    return Response(
        status_code=201,
        headers={},
        description=jsonify(
            {
                "id": doctor.id,
            },
        ),
    )


class DoctorNoPassword(BaseDoctor):
    id: str
    firstName: str
    lastName: str
    email: str


@app.get("/api/doctors")
async def get_doctors(request):
    doctors = await DoctorNoPassword.prisma().find_many()
    return json.dumps(doctors, indent=2)


@app.post("/api/patients/register")
async def register_patient(request, body: RegisterBody):
    data = request.json()
    first_name = data["firstName"]
    last_name = data["lastName"]
    email = data["email"]
    password = data["password"]

    pass_hash = hashpw(password.encode("utf-8"), gensalt())

    patient = await Patient.prisma().create(
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
        description=jsonify(
            {
                "id": patient.id,
            },
        ),
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
        return Response(
            status_code=OK,
            headers={},
            description=jsonify(
                {
                    "id": user.id,
                }
            ),
        )

    print("Invalid credentials")
    return Response(status_code=UNAUTHORIZED, headers={}, description="Unauthorized")


@app.post("/api/doctors/login")
async def doctor_login(request, body: LoginBody):
    data = request.json()
    email = data.get("email")
    password = data.get("password")

    user = await Doctor.prisma().find_first(
        where={"email": email},
    )

    if user and bcrypt.checkpw(
        password.encode("utf-8"), Base64.decode(user.password_hash)
    ):
        print(f"Doctor {user.id} logged in")
        return Response(
            status_code=OK,
            headers={},
            description=jsonify(
                {
                    "id": user.id,
                }
            ),
        )

    print("Invalid credentials")
    return Response(status_code=UNAUTHORIZED, headers={}, description="Unauthorized")


from livekit import api
import random


@app.get("/api/getvideotoken")
async def getvideotoken(request):
    roomName = "my-room"
    await createRoom("my-room")

    LK_API_KEY = "api_key"
    LK_API_SECRET = "api_secret"
    identity = str(random.randint(1000, 9999))
    print(identity)
    token = api.AccessToken(
        api_key=LK_API_KEY, api_secret=LK_API_SECRET
    )  # 1 hour validity
    token.with_identity(identity=identity)
    token.with_name(name=identity)
    token.with_grants(
        api.VideoGrants(
            room_join=True,
            room="my-room",
        )
    )

    videotoken = token.to_jwt()

    print(videotoken)

    return Response(status_code=OK, headers={}, description=videotoken)


# NETWORKIP = "10.0.2.65"
NETWORKIP = "100.80.52.9"


async def createRoom(roomName):
    try:
        LK_API_KEY = "api_key"
        LK_API_SECRET = "api_secret"
        # LIVEKITURL = "https://l6mmsls1-7880.euw.devtunnels.ms/"
        LIVEKITURL = f"http://{NETWORKIP}:7880"
        lkapi = api.LiveKitAPI(LIVEKITURL, LK_API_KEY, LK_API_SECRET)
        rooms = (
            await lkapi.room.list_rooms(api.ListRoomsRequest(names=[roomName]))
        ).rooms
        if len(rooms) > 0:
            return

        room_info = await lkapi.room.create_room(
            api.CreateRoomRequest(name=roomName),
        )
        print(room_info)
    finally:
        await lkapi.aclose()


if __name__ == "__main__":
    app.start(host="0.0.0.0", port=8080)
