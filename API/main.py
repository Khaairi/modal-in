import fastapi as _fastapi
from fastapi.middleware.cors import CORSMiddleware
import services as _services, schemas as _schemas
import sqlalchemy.orm as _orm

app = _fastapi.FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

_services.create_database()


@app.post("/borrowers/", response_model=_schemas.Borrower)
def create_borrower(
    borrower: _schemas.BorrowerCreate,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    db_borrower = _services.get_borrower_by_email(db=db, email=borrower.email)
    if db_borrower:
        raise _fastapi.HTTPException(status_code=400, detail="email already use")
    return _services.create_borrower(db=db, borrower=borrower)


@app.delete("/borrowers/delete/{borrower_id}")
def delete_borrower(
    borrower_id: int, db: _orm.Session = _fastapi.Depends(_services.get_db)
):
    _services.delete_borrower(db=db, borrower_id=borrower_id)
    return {"message": f"successfully deleted borrower with id: {borrower_id}"}


@app.post("/umkm/", response_model=_schemas.Umkm)
def create_umkm(
    umkm: _schemas.UmkmCreate,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.create_umkm(db=db, umkm=umkm)


@app.delete("/umkm/delete/{umkm_id}")
def delete_umkm(umkm_id: int, db: _orm.Session = _fastapi.Depends(_services.get_db)):
    _services.delete_umkm(db=db, umkm_id=umkm_id)
    return {"message": f"successfully deleted umkm with id: {umkm_id}"}


@app.post("/borrowers/login/", response_model=_schemas.Borrower)
def login_borrower(
    borrower: _schemas.BorrowerLogin,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    db_borrower = _services.get_borrower_login(db=db, borrower=borrower)
    if db_borrower is None:
        raise _fastapi.HTTPException(
            status_code=404, detail="sorry this user does not exist"
        )
    elif db_borrower == "password salah":
        raise _fastapi.HTTPException(status_code=405, detail="password incorrect")
    return db_borrower


@app.get("/borrowers/{borrower_id}")
def get_borrower_by_id(
    borrower_id: int, db: _orm.Session = _fastapi.Depends(_services.get_db)
):
    db_borrower = _services.get_borrower_by_id(db=db, borrower_id=borrower_id)
    if db_borrower is None:
        raise _fastapi.HTTPException(
            status_code=404, detail="sorry this user does not exist"
        )
    return db_borrower


@app.patch("/update_borrower_patch/{id}", response_model=_schemas.BorrowerPatch)
def update_borrower_patch(
    id: int,
    m: _schemas.BorrowerPatch,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    try:  # Replace with your database URL
        existing_borrower = _services.get_borrower_by_id(db=db, borrower_id=id)

        if existing_borrower:
            if m.nama != "kosong":
                existing_borrower.nama = m.nama
            if m.email != "kosong":
                existing_borrower.email = m.email
            if m.password != "kosong":
                existing_borrower.password = m.password
            if m.saku != -9999:
                existing_borrower.saku = m.saku
            # if m.id != -9999:
            #     existing_borrower.id = m.id
            if m.telp != "kosong":
                existing_borrower.telp = m.telp
            # if m.ktp != "kosong":
            #     existing_borrower.ktp = m.ktp

            db.commit()
            db.refresh(existing_borrower)
            # response.headers["location"] = "/mahasixswa/{}".format(id)
        else:
            raise _fastapi.HTTPException(status_code=404, detail="Item Not Found")

    except Exception as e:
        raise _fastapi.HTTPException(
            status_code=500, detail="Terjadi exception: {}".format(str(e))
        )

    return m


@app.post("/riwayat/", response_model=_schemas.Riwayat)
def create_riwayat(
    riwayat: _schemas.RiwayatCreate,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.create_riwayat(db=db, riwayat=riwayat)

@app.post("/ajuan/", response_model=_schemas.Ajuan)
def create_ajuan(
    ajuan: _schemas.AjuanCreate,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.create_ajuan(db=db, ajuan=ajuan)


# @app.get("/borrowers/login/", response_model=_schemas.Borrower)
# def login_borrower(
#     email: str,
#     password: str,
#     db: _orm.Session = _fastapi.Depends(_services.get_db),
# ):
#     db_borrower = _services.get_borrower_login(db=db, email=email, password=password)
#     if db_borrower is None:
#         raise _fastapi.HTTPException(
#             status_code=404, detail="sorry this user does not exist"
#         )
#     elif db_borrower == "password salah":
#         raise _fastapi.HTTPException(status_code=405, detail="password incorrect")
#     return db_borrower
