from robyn import Robyn, Response
#user list
users = {
    "test@example.com": "password123",
    "admin@example.com": "adminpass",
}

app = Robyn(__file__)

@app.post("/api/login")
async def login(request):

    data = request.json()
    email = data.get("email")
    password = data.get("password")

    if email in users and users[email] == password:
        print("Login success")
        return Response(status_code=200, headers={}, description="OK")
    else:
        print("Login failed")
        return Response(status_code=401, headers={}, description="Unauthorized")

if __name__ == "__main__":
    app.start(port=8000)
