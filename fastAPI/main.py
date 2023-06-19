import fastapi as _fastapi
from fastapi.middleware.cors import CORSMiddleware
import services as _services, schemas as _schemas
import sqlalchemy.orm as _orm
import fastapi.security as _security
from typing import List
from datetime import datetime
from fastapi import File, UploadFile
from fastapi.responses import FileResponse

app = _fastapi.FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

_services.create_database()


@app.post("/borrowers/")
def create_borrower(
    borrower: _schemas.BorrowerCreate,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    db_borrower = _services.get_borrower_by_email(db=db, email=borrower.email)
    db_lender = _services.get_lender_by_email(db=db, email=borrower.email)
    if db_borrower or db_lender:
        raise _fastapi.HTTPException(status_code=400, detail="email already use")

    user = _services.create_borrower(db=db, borrower=borrower)
    return _services.create_token(borrower=user)


@app.post("/borrower/token/")
def generate_token(
    form_data: _security.OAuth2PasswordRequestForm = _fastapi.Depends(),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    borrower = _services.authenticate_borrower(
        email=form_data.username, password=form_data.password, db=db
    )
    if not borrower:
        raise _fastapi.HTTPException(status_code=401, detail="Invalid Credentials")

    return _services.create_token(borrower=borrower)


@app.get("/borrower/me/", response_model=_schemas.Borrower)
def get_borrower(
    borrower: _schemas.Borrower = _fastapi.Depends(_services.get_current_borrower),
):
    return borrower


@app.delete("/borrowers/delete/{borrower_id}")
def delete_borrower(
    borrower_id: int, db: _orm.Session = _fastapi.Depends(_services.get_db)
):
    _services.delete_borrower(db=db, borrower_id=borrower_id)
    return {"message": f"successfully deleted borrower with id: {borrower_id}"}


@app.post("/umkm/", response_model=_schemas.Umkm)
def create_umkm(
    umkm: _schemas.UmkmCreate,
    borrower: _schemas.Borrower = _fastapi.Depends(_services.get_current_borrower),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.create_umkm(db=db, umkm=umkm, borrower=borrower)


@app.delete("/umkm/delete/{umkm_id}")
def delete_umkm(umkm_id: int, db: _orm.Session = _fastapi.Depends(_services.get_db)):
    _services.delete_umkm(db=db, umkm_id=umkm_id)
    return {"message": f"successfully deleted umkm with id: {umkm_id}"}


@app.patch("/update_borrower_patch/", response_model=_schemas.BorrowerPatch)
def update_borrower_patch(
    m: _schemas.BorrowerPatch,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
    borrower: _schemas.Borrower = _fastapi.Depends(_services.get_current_borrower),
):
    return _services.patch_borrower(db=db, borrower=borrower, m=m)


@app.post("/riwayat/", response_model=_schemas.Riwayat)
def create_riwayat(
    riwayat: _schemas.RiwayatCreate,
    borrower: _schemas.Borrower = _fastapi.Depends(_services.get_current_borrower),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.create_riwayat(db=db, riwayat=riwayat, borrower=borrower)


@app.post("/riwayatLender/", response_model=_schemas.RiwayatLender)
def create_riwayat_lender(
    riwayat: _schemas.RiwayatLenderCreate,
    lender: _schemas.Lender = _fastapi.Depends(_services.get_current_lender),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.create_riwayat_lender(db=db, riwayat=riwayat, lender=lender)


@app.post("/ajuan/", response_model=_schemas.Ajuan)
def create_ajuan(
    ajuan: _schemas.AjuanCreate,
    borrower: _schemas.Borrower = _fastapi.Depends(_services.get_current_borrower),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.create_ajuan(db=db, ajuan=ajuan, borrower=borrower)


@app.delete("/ajuan/delete/{ajuan_id}")
def delete_ajuan(ajuan_id: int, db: _orm.Session = _fastapi.Depends(_services.get_db)):
    _services.delete_ajuan(db=db, ajuan_id=ajuan_id)
    return {"message": f"successfully deleted ajuan with id: {ajuan_id}"}


@app.get("/borrower/riwayat/", response_model=List[_schemas.Riwayat])
def get_borrower_riwayat(
    borrower: _schemas.Borrower = _fastapi.Depends(_services.get_current_borrower),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.get_current_borrower_riwayat(db=db, borrower=borrower)


@app.post("/lenders/")
def create_lender(
    lender: _schemas.LenderCreate,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    db_borrower = _services.get_borrower_by_email(db=db, email=lender.email)
    db_lender = _services.get_lender_by_email(db=db, email=lender.email)
    if db_lender or db_borrower:
        raise _fastapi.HTTPException(status_code=400, detail="email already use")

    user = _services.create_lender(db=db, lender=lender)
    return _services.create_token_lender(lender=user)


@app.post("/lender/token/")
def generate_token_lender(
    form_data: _security.OAuth2PasswordRequestForm = _fastapi.Depends(),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    lender = _services.authenticate_lender(
        email=form_data.username, password=form_data.password, db=db
    )
    if not lender:
        raise _fastapi.HTTPException(status_code=401, detail="Invalid Credentials")

    return _services.create_token_lender(lender=lender)


@app.get("/lender/me/", response_model=_schemas.Lender)
def get_lender(
    lender: _schemas.Lender = _fastapi.Depends(_services.get_current_lender),
):
    return lender


@app.post("/riwayatLender/", response_model=_schemas.RiwayatLender)
def create_riwayat_lender(
    riwayat: _schemas.RiwayatLenderCreate,
    lender: _schemas.Lender = _fastapi.Depends(_services.get_current_lender),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.create_riwayat_lender(db=db, riwayat=riwayat, lender=lender)


@app.get("/lender/riwayat/", response_model=List[_schemas.RiwayatLender])
def get_lender_riwayat(
    lender: _schemas.Lender = _fastapi.Depends(_services.get_current_lender),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.get_current_lender_riwayat(db=db, lender=lender)


@app.get("/borrower/market/", response_model=_schemas.Market)
def get_borrower_market(
    borrower: _schemas.Borrower = _fastapi.Depends(_services.get_current_borrower),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.get_current_borrower_market(db=db, borrower=borrower)


@app.get("/borrower/ajuan/", response_model=_schemas.Ajuan)
def get_borrower_ajuan(
    borrower: _schemas.Borrower = _fastapi.Depends(_services.get_current_borrower),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.get_current_borrower_ajuan(db=db, borrower=borrower)


@app.patch("/update_lender_patch/", response_model=_schemas.LenderPatch)
def update_lender_patch(
    m: _schemas.LenderPatch,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
    lender: _schemas.Lender = _fastapi.Depends(_services.get_current_lender),
):
    return _services.patch_lender(db=db, lender=lender, m=m)


@app.patch("/update_market_patch/{id}", response_model=_schemas.MarketPatch)
def update_market_patch(
    id: int,
    m: _schemas.MarketPatch,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.patch_market(db=db, m=m, id=id)


@app.get("/markets/", response_model=List[_schemas.Market])
def get_markets(
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.get_markets(db=db)


@app.get("/ajuan/{ajuan_id}", response_model=_schemas.Ajuan)
def get_ajuan_by_ajuan_id(
    ajuan_id: int,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.get_ajuan_by_id(db=db, ajuan_id=ajuan_id)


@app.get("/market/{market_id}", response_model=_schemas.Market)
def get_market_by_market_id(
    market_id: int,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.get_market_by_id(db=db, market_id=market_id)


@app.get("/borrower/{ajuan_id}", response_model=_schemas.Borrower)
def get_borrower_by_ajuan_id(
    ajuan_id: int,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.get_borrower_by_ajuan_id(db=db, ajuan_id=ajuan_id)


@app.post("/pendanaan/", response_model=_schemas.Pendanaan)
def create_pendanaan(
    pendanaan: _schemas.PendanaanCreate,
    lender: _schemas.Lender = _fastapi.Depends(_services.get_current_lender),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.create_pendanaan(db=db, pendanaan=pendanaan, lender=lender)


@app.patch("/update_ajuan_patch/{id}", response_model=_schemas.AjuanPatch)
def update_ajuan_patch(
    id: int,
    m: _schemas.AjuanPatch,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.bayar_pinjaman(db=db, m=m, id=id)


@app.get("/borrower/activity/", response_model=List[_schemas.ActivityBorrower])
def get_borrower_activity(
    borrower: _schemas.Borrower = _fastapi.Depends(_services.get_current_borrower),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.get_current_borrower_activity(db=db, borrower=borrower)


@app.get("/lender/activity/", response_model=List[_schemas.ActivityLender])
def get_lender_activity(
    lender: _schemas.Lender = _fastapi.Depends(_services.get_current_lender),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.get_current_lender_activity(db=db, lender=lender)


@app.get("/borrower/pendana/{id}", response_model=List[_schemas.Pendanaan])
def get_borrower_pendana(
    id: int,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.get_borrower_pendana(db=db, id=id)


@app.get("/lender/{id}", response_model=_schemas.Lender)
def get_lender(
    id: int,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.get_lender_by_id(db=db, lender_id=id)


@app.get("/borrowerr/{id}", response_model=_schemas.Borrower)
def get_borrower(
    id: int,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.get_borrower_by_id(db=db, borrower_id=id)


@app.get("/borrower/notifikasi/", response_model=List[_schemas.NotifikasiBorrower])
def get_borrower_notifikasi(
    borrower: _schemas.Borrower = _fastapi.Depends(_services.get_current_borrower),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.get_current_borrower_notifikasi(db=db, borrower=borrower)


@app.get("/lender/notifikasi/", response_model=List[_schemas.NotifikasiLender])
def get_lender_notifikasi(
    lender: _schemas.Lender = _fastapi.Depends(_services.get_current_lender),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.get_current_lender_notifikasi(db=db, lender=lender)


@app.patch("/borrower/notifikasi/read/")
def update_borrower_notifikasi(
    borrower: _schemas.Borrower = _fastapi.Depends(_services.get_current_borrower),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.update_borrower_notifikasi(db=db, borrower=borrower)


@app.patch("/lender/notifikasi/read/")
def update_lender_notifikasi(
    lender: _schemas.Lender = _fastapi.Depends(_services.get_current_lender),
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.update_lender_notifikasi(db=db, lender=lender)


@app.post("/uploadimage")
def upload(file: UploadFile = File(...)):
    try:
        print("mulai upload")
        print(file.filename)
        contents = file.file.read()
        with open("./data_file/" + file.filename, "wb") as f:
            f.write(contents)
    except Exception:
        return {"message": "Error upload file"}
    finally:
        file.file.close()

    return {"message": f"Upload berhasil: {file.filename}"}


@app.get("/getimage/{nama_file}")
async def getImage(nama_file: str):
    return FileResponse("./data_file/" + nama_file)


@app.get("/lender/pendana/", response_model=List[_schemas.Pendanaan])
def get_lender_pendana(
    db: _orm.Session = _fastapi.Depends(_services.get_db),
    lender: _schemas.Lender = _fastapi.Depends(_services.get_current_lender),
):
    return _services.get_lender_pendana(db=db, lender=lender)


# @app.get("/borrowers/me/delete/", response_model=_schemas.Borrower)
# def delete_current_borrower(
#     borrower: _schemas.Borrower = _fastapi.Depends(_services.get_current_borrower),
#     db: _orm.Session = _fastapi.Depends(_services.get_db),
# ):
#     return _services.delete_current_borrower(db=db, borrower=borrower)


# @app.patch("/update_ajuan_patch/{id}", response_model=_schemas.AjuanPatch)
# def update_ajuan_patch(
#     id: int,
#     m: _schemas.AjuanPatch,
#     db: _orm.Session = _fastapi.Depends(_services.get_db),
# ):
#     return _services.bayar_pinjaman(db=db, m=m, id=id)


# cek penggalangan


# @app.on_event("startup")
# @repeat_every(seconds=15)

# from apscheduler.schedulers.background import BackgroundScheduler
# from fastapi import BackgroundTasks
# from sqlalchemy.orm import Session
# import asyncio
# import aiocron

# scheduler = BackgroundScheduler()


# @app.get("/")
# async def index(background_tasks: BackgroundTasks):
#     background_tasks.add_task(update_campaign_status)
#     return {"message": "Task scheduled"}


# @app.on_event("startup")
# def start_scheduler():
#     scheduler.start()


# @app.on_event("shutdown")
# def stop_scheduler():
#     scheduler.shutdown()


# def update_campaign_status(db: _orm.Session = _fastapi.Depends(_services.get_db)):
#     current_time = datetime.datetime.now()
#     active_campaigns = _services.get_marketss()
#     for campaign in active_campaigns:
#         end_time = campaign.tenggat_pendanaan
#         if current_time >= end_time:
#             campaign.status = "donpenggalangan"
#             db.commit()
#             db.refresh(campaign)


# @app.patch("/market/don/")
# async def update_campaign_status_endpoint(
#     background_tasks: BackgroundTasks,
#     db: _orm.Session = _fastapi.Depends(_services.get_db),
# ):
#     print("masuk")
#     background_tasks.add_task(update_campaign_status, db)
#     return {"message": "Task scheduled"}


# @app.task("interval", id="my_task", seconds=10)
# @app.patch("/market/don/")
# async def update_campaign_status(
#     background_tasks: _fastapi.BackgroundTasks,
#     db: _orm.Session = _fastapi.Depends(_services.get_db),
# ):
#     print("masuk")
#     # Mendapatkan waktu sekarang
#     # Mendapatkan daftar penggalangan yang masih aktif dari database (contoh)
#     current_time = datetime.datetime.now()
#     active_campaigns = []
#     try:
#         active_campaigns = _services.get_marketss()
#         print("error ga")
#     except Exception as e:
#         print(f"An error occurred: {str(e)}")
#     for campaign in active_campaigns:
#         print("masuk2")
#         end_time = campaign.tenggat_pendanaan  # Tanggal berakhirnya penggalangan
#         print(end_time)

#         # Membandingkan waktu sekarang dengan tanggal berakhir
#         if current_time >= end_time:
#             # Mengubah status penggalangan menjadi "selesai_penggalangan"
#             campaign.status = "donpenggalangan"
#             # Simpan perubahan ke database (contoh)
#             db.commit()
#             db.refresh(campaign)


# async def schedule_update_campaign_status():
#     await asyncio.sleep(10)
#     while True:
#         background_tasks = _fastapi.BackgroundTasks()
#         await update_campaign_status(background_tasks)
#         await asyncio.sleep(60)


# # Start the scheduler
# asyncio.create_task(schedule_update_campaign_status())


# # # Schedule the function to run every one minute
# # def schedule_update_campaign_status():
# #     asyncio.create_task(update_campaign_status())
# #     loop = asyncio.get_event_loop()
# #     loop.call_later(60, schedule_update_campaign_status)


# # # Start the scheduler
# # schedule_update_campaign_status()
