from http.client import OK, UNAUTHORIZED
from prisma import Prisma
from prisma.models import User

from robyn import Response, Robyn

app = Robyn(__file__)
prisma = Prisma(auto_register=True)


@app.startup_handler
async def startup_handler() -> None:
    await prisma.connect()


@app.shutdown_handler
async def shutdown_handler() -> None:
    if prisma.is_connected():
        await prisma.disconnect()


@app.get("/")
async def h():
    user = await User.prisma().create(
        data={
            "name": "Robert",
        },
    )
    return user.model_dump_json(indent=2)


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
