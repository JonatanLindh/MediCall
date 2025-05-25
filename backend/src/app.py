from typing import Optional
from livekit import api
import random
from http.client import OK, UNAUTHORIZED
import json
from bcrypt import gensalt, hashpw
import bcrypt
from prisma import Base64, Prisma
from prisma.models import Doctor, Patient, Report
from prisma.bases import BaseDoctor
from prisma.types import ReportUpdateInput
from robyn import Response, Robyn, WebSocket
from robyn.types import Body

app = Robyn(__file__)
websocket = WebSocket(app, "/ws")
prisma = Prisma(auto_register=True)
global lkapi

@app.startup_handler
async def startup_handler() -> None:
    global lkapi 
    lkapi = api.LiveKitAPI(LIVEKITURL, LK_API_KEY, LK_API_SECRET)
    await prisma.connect()


@app.shutdown_handler
async def shutdown_handler() -> None:
    if prisma.is_connected():
        await prisma.disconnect()
    await lkapi.aclose()  


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


class UpdateDoctorStatusBody(Body):
    status: str


# TODO add auth
@app.patch("/api/doctors/:id/status")
async def update_doctor_status(request, body: UpdateDoctorStatusBody):
    id = request.path_params["id"]
    data = request.json()
    status = data["status"]

    print(f"Updating doctor {id} status to {status}")

    await Doctor.prisma().update(
        where={"id": id},
        data={
            "status": status,
        },
    )


@app.get("/api/doctors/:id/status")
async def get_doctor_status(request):
    id = request.path_params["id"]
    doctor = await Doctor.prisma().find_unique(
        where={"id": id},
    )
    if doctor:
        return json.dumps(
            {
                "status": doctor.status,
            },
            indent=2,
        )
    else:
        return Response(status_code=404, description="Doctor not found", headers={})


# REPORT
class ReportBody(Body):
    patientId: str
    doctorId: str
    description: str
    status: str


@app.post("/api/reports")
async def create_report(request, body: ReportBody):
    data = request.json()
    patient_id = data["patientId"]
    doctor_id = data["doctorId"]
    description = data["description"]
    status = data["status"]

    await Report.prisma().create(
        data={
            "patientId": patient_id,
            "doctorId": doctor_id,
            "description": description,
            "status": status,
        },
    )

    return Response(
        status_code=201,
        headers={},
        description="Report created successfully",
    )


class UpdateReportBody(Body):
    status: Optional[str]
    completed: Optional[bool]


@app.patch("/api/reports/:id")
async def update_report(request, body: UpdateReportBody):
    id = request.path_params["id"]
    data = request.json()
    status = data.get("status")
    completed = data.get("completed")

    update_data: ReportUpdateInput = {}
    if status is not None:
        update_data["status"] = status
    if completed is not None:
        update_data["completed"] = completed

    await Report.prisma().update(
        where={"id": id},
        data=update_data,
    )

    return Response(
        status_code=200,
        headers={},
        description="Report updated successfully",
    )


@app.get("/api/reports/:id")
async def get_report(request):
    id = request.path_params["id"]
    report = await Report.prisma().find_unique(
        where={"id": id},
    )
    if report:
        return json.dumps(report, indent=2)
    else:
        return Response(status_code=404, description="Report not found", headers={})


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


NETWORKIP = "10.0.12.4"
# NETWORKIP = "192.168.9.51"
LK_API_KEY = "api_key"
LK_API_SECRET = "api_secret"
# LIVEKITURL = "https://l6mmsls1-7880.euw.devtunnels.ms/"
LIVEKITURL = f"http://{NETWORKIP}:7880"

@app.get("/api/getvideotoken")
async def get_videotoken(request):
    identity = str(random.randint(1000, 9999))
    print(identity)

    roomName = identity
    await createRoom(roomName)

    videotoken = videotokenFrom(identity,roomName)

    print(videotoken)

    return Response(status_code=OK, headers={}, description=videotoken)


@app.get("/api/getvideotoken/:roomName")
async def get_videotoken_with_roomname(request):
    print("HAHAHAAH")
    identity = str(random.randint(1000, 9999))
    print(identity)

    roomName =  request.path_params["roomName"]

    videotoken = videotokenFrom(identity,roomName)

    print(videotoken)

    return Response(status_code=OK, headers={}, description=videotoken)


@app.get("/api/getallrooms")
async def get_all_rooms(request):
    rooms = await getAllRooms()
    roomNames = [room.name for room in  rooms]
    
    return Response(status_code=OK, headers={}, description=json.dumps(roomNames))



def videotokenFrom(identity, roomName):
    token = api.AccessToken(
        api_key=LK_API_KEY, api_secret=LK_API_SECRET
    )  # 1 hour validity
    token.with_identity(identity=identity)
    token.with_name(name=identity)
    token.with_grants(
        api.VideoGrants(
            room_join=True,
            room=roomName,
        )
    )

    videotoken = token.to_jwt()
    return videotoken

async def createRoom(roomName):
    rooms = (
        await lkapi.room.list_rooms(api.ListRoomsRequest(names=[roomName]))
    ).rooms
    if len(rooms) > 0:
        return
    room_info = await lkapi.room.create_room(
        api.CreateRoomRequest(name=roomName, empty_timeout=5),
    )


async def getAllRooms():
    rooms = ( await lkapi.room.list_rooms(api.ListRoomsRequest())).rooms
    return rooms


if __name__ == "__main__":
    app.start(host="0.0.0.0", port=8080)

