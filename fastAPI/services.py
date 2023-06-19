import database as _database, models as _models, schemas as _schemas
import sqlalchemy.orm as _orm
import passlib.hash as _hash
import jwt as _jwt
import fastapi as _fastapi
import fastapi.security as _security
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta

_JWT_SECRET = "thisisnotverysafe"
oauth2schema = _security.OAuth2PasswordBearer(
    tokenUrl="/borrower/token/", scheme_name="oauth2schema"
)
oauth2schemaLender = _security.OAuth2PasswordBearer(
    tokenUrl="/lender/token/", scheme_name="oauth2schemaLender"
)


def create_database():
    return _database.Base.metadata.create_all(bind=_database.engine)


def get_db():
    db = _database.SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_borrower_by_email(db: _orm.Session, email: str):
    return db.query(_models.Borrower).filter(_models.Borrower.email == email).first()


def get_borrower_by_id(db: _orm.Session, borrower_id: int):
    return db.query(_models.Borrower).filter(_models.Borrower.id == borrower_id).first()


def create_borrower(db: _orm.Session, borrower: _schemas.BorrowerCreate):
    hashed_password = _hash.bcrypt.hash(borrower.password)
    db_borrower = _models.Borrower(
        nama=borrower.nama,
        email=borrower.email,
        password=hashed_password,
        telp=borrower.telp,
        ktp=borrower.ktp,
        saku=borrower.saku,
        status=borrower.status,
    )
    db.add(db_borrower)
    db.commit()
    db.refresh(db_borrower)
    return db_borrower


def create_token(borrower: _models.Borrower):
    borrower_schema_obj = _schemas.Borrower.from_orm(borrower)
    borrower_dict = borrower_schema_obj.dict()

    expires = datetime.utcnow() + timedelta(minutes=60)
    borrower_dict["exp"] = expires

    token = _jwt.encode(borrower_dict, _JWT_SECRET)
    return dict(access_token=token, token_type="bearer")


def authenticate_borrower(email: str, password: str, db: _orm.Session):
    borrower = get_borrower_by_email(email=email, db=db)

    if not borrower:
        return False

    if not borrower.verify_password(passwords=password):
        return False

    return borrower


def get_current_borrower(
    db: _orm.Session = _fastapi.Depends(get_db),
    token: str = _fastapi.Depends(oauth2schema),
):
    try:
        payload = _jwt.decode(token, _JWT_SECRET, algorithms=["HS256"])
        borrower = db.query(_models.Borrower).get(payload["id"])
    except:
        raise _fastapi.HTTPException(
            status_code=401, detail="Email Atau Password Salah"
        )

    return _schemas.Borrower.from_orm(borrower)


def delete_borrower(db: _orm.Session, borrower_id: int):
    db.query(_models.Borrower).filter(_models.Borrower.id == borrower_id).delete()
    db.commit()


def create_umkm(
    db: _orm.Session, umkm: _schemas.UmkmCreate, borrower: _schemas.Borrower
):
    db_umkm = _models.Umkm(
        nama=umkm.nama,
        alamat=umkm.alamat,
        kategori=umkm.kategori,
        penghasilan=umkm.penghasilan,
        fotoUmkm=umkm.fotoUmkm,
        npwp=umkm.npwp,
        dokumen=umkm.dokumen,
        borrower_id=borrower.id,
    )
    db.add(db_umkm)
    db.commit()
    db.refresh(db_umkm)
    return _schemas.Umkm.from_orm(db_umkm)


def delete_umkm(db: _orm.Session, umkm_id: int):
    db.query(_models.Umkm).filter(_models.Umkm.id == umkm_id).delete()
    db.commit()


def create_riwayat(
    db: _orm.Session, riwayat: _schemas.RiwayatCreate, borrower: _schemas.Borrower
):
    db_riwayat = _models.RiwayatBorrower(
        borrower_id=borrower.id,
        nominal=riwayat.nominal,
        status=riwayat.status,
    )
    db.add(db_riwayat)
    db.commit()
    db.refresh(db_riwayat)
    return db_riwayat


def create_ajuan(
    db: _orm.Session, ajuan: _schemas.AjuanCreate, borrower: _schemas.Borrower
):
    db_ajuan = _models.Ajuan(
        besar_biaya=ajuan.besar_biaya,
        tenor_pendanaan=ajuan.tenor_pendanaan,
        minimal_biaya=ajuan.minimal_biaya,
        opsi_pengembalian=ajuan.opsi_pengembalian,
        status=ajuan.status,
        bunga=ajuan.bunga,
        sisa_pengembalian=ajuan.sisa_pengembalian,
        borrower_id=borrower.id,
    )
    db.add(db_ajuan)
    db.commit()
    db.refresh(db_ajuan)

    db_notif = _models.NotifikasiBorrower(
        borrower_id=borrower.id,
        title="Pengajuan Berhasil Dikirim!",
        deskripsi="Pengajuan telah berhasil dikirim, silahkan untuk menunggu hasil konfirmasi",
        status="belum",
    )
    db.add(db_notif)
    db.commit()
    db.refresh(db_notif)

    return db_ajuan


def delete_ajuan(db: _orm.Session, ajuan_id: int):
    db.query(_models.Ajuan).filter(_models.Ajuan.id == ajuan_id).delete()
    db.commit()


def get_ajuan_by_borrower(db: _orm.Session, borrower_id: int):
    return (
        db.query(_models.Ajuan)
        .filter(
            _models.Ajuan.borrower_id == borrower_id,
            _models.Ajuan.status == "mengajukan",
        )
        .first()
    )


def create_market(
    db: _orm.Session, market: _schemas.MarketCreate, ajuan: _schemas.Ajuan
):
    tenggat = datetime.now() + relativedelta(months=1)
    # tenggat = datetime.now() + relativedelta(minutes=1)
    db_market = _models.Market(
        ajuan_id=ajuan.id,
        dana_terkumpul=0,
        tenggat_pendanaan=tenggat,
        status="penggalangan",
    )
    db.add(db_market)
    db.commit()
    db.refresh(db_market)
    return db_market


def get_market_by_id(db: _orm.Session, market_id: int):
    return db.query(_models.Market).filter(_models.Market.id == market_id).first()


def get_markets(db: _orm.Session):
    markets = db.query(_models.Market).filter(_models.Market.status == "penggalangan")
    return list(map(_schemas.Market.from_orm, markets))


# def get_marketss(db: _orm.Session = _fastapi.Depends(get_db)):
#     return db.query(_models.Market).filter(_models.Market.status == "penggalangan")


def patch_market(db: _orm.Session, m: _schemas.MarketPatch, id: int):
    existing_market = get_market_by_id(db=db, market_id=id)

    if existing_market:
        if m.dana_terkumpul != -9999:
            existing_market.dana_terkumpul = m.dana_terkumpul
        if m.status != "kosong":
            existing_market.status = m.status

        db.commit()
        db.refresh(existing_market)
    else:
        raise _fastapi.HTTPException(status_code=404, detail="Item Not Found")

    return m


def get_current_borrower_market(db: _orm.Session, borrower: _schemas.Borrower):
    ajuan = get_ajuan_by_borrower(db=db, borrower_id=borrower.id)
    market = db.query(_models.Market).filter_by(ajuan_id=ajuan.id).first()

    return market


def get_current_borrower_ajuan(db: _orm.Session, borrower: _schemas.Borrower):
    ajuan = get_ajuan_by_borrower(db=db, borrower_id=borrower.id)

    return ajuan


def get_current_borrower_riwayat(db: _orm.Session, borrower: _schemas.Borrower):
    riwayat = db.query(_models.RiwayatBorrower).filter_by(borrower_id=borrower.id)

    return list(map(_schemas.Riwayat.from_orm, riwayat))


def patch_ajuan(
    db: _orm.Session,
    ajuan: _schemas.Ajuan,
):
    new_tenggat = datetime.now() + relativedelta(months=1 + ajuan.tenor_pendanaan)

    ajuan.tenggat_pengembalian = new_tenggat

    db.commit()
    db.refresh(ajuan)


def notif_diterima(db: _orm.Session, borrower_id: int):
    db_notif = _models.NotifikasiBorrower(
        borrower_id=borrower_id,
        title="Pengajuan Telah Dikonfirmasi!",
        deskripsi="SELAMAT! Pengajuan telah dikonfirmasi, UMKM anda telah masuk ke daftar marketplace kami",
        status="belum",
    )
    db.add(db_notif)
    db.commit()
    db.refresh(db_notif)


def patch_borrower(
    db: _orm.Session, borrower: _schemas.Borrower, m: _schemas.BorrowerPatch
):
    existing_borrower = get_borrower_by_id(db=db, borrower_id=borrower.id)

    if existing_borrower:
        if m.nama != "kosong":
            existing_borrower.nama = m.nama
        if m.email != "kosong":
            existing_borrower.email = m.email
        if m.password != "kosong":
            existing_borrower.password = m.password
        if m.saku != -9999:
            existing_borrower.saku = m.saku
        if m.telp != "kosong":
            existing_borrower.telp = m.telp
        if m.status != "kosong":
            existing_borrower.status = m.status

        if m.status == "diterima":
            existing_ajuan = get_ajuan_by_borrower(
                db=db, borrower_id=existing_borrower.id
            )
            notif_diterima(db=db, borrower_id=existing_borrower.id)
            create_market(ajuan=existing_ajuan, db=db, market=_schemas.MarketCreate)
            patch_ajuan(ajuan=existing_ajuan, db=db)

        db.commit()
        db.refresh(existing_borrower)
    else:
        raise _fastapi.HTTPException(status_code=404, detail="Item Not Found")

    return m


def get_lender_by_id(db: _orm.Session, lender_id: int):
    return db.query(_models.Lender).filter(_models.Lender.id == lender_id).first()


def get_lender_by_email(db: _orm.Session, email: str):
    return db.query(_models.Lender).filter(_models.Lender.email == email).first()


def create_lender(db: _orm.Session, lender: _schemas.LenderCreate):
    hashed_password = _hash.bcrypt.hash(lender.password)
    db_lender = _models.Lender(
        nama=lender.nama,
        email=lender.email,
        password=hashed_password,
        telp=lender.telp,
        ktp=lender.ktp,
        saku=lender.saku,
        status=lender.status,
    )
    db.add(db_lender)
    db.commit()
    db.refresh(db_lender)
    return db_lender


def create_token_lender(lender: _models.Lender):
    lender_schema_obj = _schemas.Lender.from_orm(lender)
    lender_dict = lender_schema_obj.dict()

    expires = datetime.utcnow() + timedelta(minutes=60)
    lender_dict["exp"] = expires

    token = _jwt.encode(lender_dict, _JWT_SECRET)
    return dict(access_token=token, token_type="bearer")


def authenticate_lender(email: str, password: str, db: _orm.Session):
    lender = get_lender_by_email(email=email, db=db)

    if not lender:
        return False

    if not lender.verify_password(passwords=password):
        return False

    return lender


def get_current_lender(
    db: _orm.Session = _fastapi.Depends(get_db),
    token: str = _fastapi.Depends(oauth2schemaLender),
):
    try:
        payload = _jwt.decode(token, _JWT_SECRET, algorithms=["HS256"])
        lender = db.query(_models.Lender).get(payload["id"])
    except:
        raise _fastapi.HTTPException(
            status_code=401, detail="Email Atau Password Salah"
        )

    return _schemas.Lender.from_orm(lender)


def patch_lender(db: _orm.Session, lender: _schemas.Lender, m: _schemas.LenderPatch):
    existing_lender = get_lender_by_id(db=db, lender_id=lender.id)

    if existing_lender:
        if m.nama != "kosong":
            existing_lender.nama = m.nama
        if m.email != "kosong":
            existing_lender.email = m.email
        if m.password != "kosong":
            existing_lender.password = m.password
        if m.saku != -9999:
            existing_lender.saku = m.saku
        if m.telp != "kosong":
            existing_lender.telp = m.telp
        if m.status != "kosong":
            existing_lender.status = m.status

        # if m.status == "diterima":
        #     existing_ajuan = get_ajuan_by_borrower(db=db, borrower_id=existing_borrower.id)
        #     create_market(ajuan=existing_ajuan, db=db, market=_schemas.MarketCreate)
        #     patch_ajuan(ajuan=existing_ajuan, db=db)

        db.commit()
        db.refresh(existing_lender)
    else:
        raise _fastapi.HTTPException(status_code=404, detail="Item Not Found")

    return m


def create_riwayat_lender(
    db: _orm.Session, riwayat: _schemas.RiwayatLenderCreate, lender: _schemas.Lender
):
    db_riwayat = _models.RiwayatLender(
        lender_id=lender.id,
        nominal=riwayat.nominal,
        status=riwayat.status,
    )
    db.add(db_riwayat)
    db.commit()
    db.refresh(db_riwayat)
    return db_riwayat


def get_current_lender_riwayat(db: _orm.Session, lender: _schemas.Lender):
    riwayat = db.query(_models.RiwayatLender).filter_by(lender_id=lender.id)

    return list(map(_schemas.RiwayatLender.from_orm, riwayat))


def get_ajuan_by_id(db: _orm.Session, ajuan_id: int):
    return db.query(_models.Ajuan).filter(_models.Ajuan.id == ajuan_id).first()


def get_umkm_by_borrower(db: _orm.Session, borrower_id: int):
    return (
        db.query(_models.Umkm).filter(_models.Umkm.borrower_id == borrower_id).first()
    )


def get_borrower_by_ajuan_id(db: _orm.Session, ajuan_id: int):
    existing_ajuan = get_ajuan_by_id(db=db, ajuan_id=ajuan_id)
    existing_borrower = get_borrower_by_id(
        db=db, borrower_id=existing_ajuan.borrower_id
    )

    return existing_borrower


def tambah_saku_borrower(
    db: _orm.Session, borrower: _schemas.Borrower, dana: int, nama: str
):
    db_activity = _models.ActivityBorrower(
        borrower_id=borrower.id,
        keterangan="Mendapatkan dana dari " + nama,
        status="penerimaan",
        biaya=dana,
    )
    db.add(db_activity)
    db.commit()
    db.refresh(db_activity)

    borrower.saku += dana
    db.commit()
    db.refresh(borrower)


def tambah_dana_terkumpul(db: _orm.Session, market: _schemas.Market, dana: int):
    market.dana_terkumpul += dana
    db.commit()
    db.refresh(market)


def kurang_dana_lender(db: _orm.Session, lender_id: int, dana: int, nama: str):
    db_activity = _models.ActivityLender(
        lender_id=lender_id,
        keterangan="Memberikan dana kepada UMKM " + nama,
        status="pembayaran",
        biaya=dana,
    )
    db.add(db_activity)
    db.commit()
    db.refresh(db_activity)

    existing_lender = get_lender_by_id(db=db, lender_id=lender_id)
    existing_lender.saku -= dana
    existing_lender.status = "sudah"
    db.commit()
    db.refresh(existing_lender)


def notif_pendanaan(db: _orm.Session, borrower_id: int, lender_id: int, dana: int):
    existing_lender = get_lender_by_id(db=db, lender_id=lender_id)
    dana_str = str(dana)
    db_notif = _models.NotifikasiBorrower(
        borrower_id=borrower_id,
        title=existing_lender.nama + " Memberikan Anda Dana!",
        deskripsi="SELAMAT! "
        + existing_lender.nama
        + " telah mendanai anda sebesar Rp "
        + dana_str,
        status="belum",
    )
    db.add(db_notif)
    db.commit()
    db.refresh(db_notif)

    existing_umkm = get_umkm_by_borrower(db=db, borrower_id=borrower_id)
    db_notif2 = _models.NotifikasiLender(
        lender_id=lender_id,
        title="Pendanaan UMKM Berhasil!",
        deskripsi="Selamat! Pendanaan untuk "
        + existing_umkm.nama
        + " berhasil dilakukan",
        status="belum",
    )
    db.add(db_notif2)
    db.commit()
    db.refresh(db_notif2)


def notif_dana_full(db: _orm.Session, borrower_id: int):
    db_notif = _models.NotifikasiBorrower(
        borrower_id=borrower_id,
        title="Pendanaan Anda Telah Mencapai 100%",
        deskripsi="SELAMAT! Pendanaan UMKM anda telah selesai dengan persentase terkumpul 100%",
        status="belum",
    )
    db.add(db_notif)
    db.commit()
    db.refresh(db_notif)


def get_pendanaan_by_lender(db: _orm.Session, lender_id: int, market_id: int):
    return (
        db.query(_models.Pendanaan)
        .filter(
            _models.Pendanaan.lender_id == lender_id,
            _models.Pendanaan.market_id == market_id,
        )
        .first()
    )


def create_pendanaan(
    db: _orm.Session, pendanaan: _schemas.PendanaanCreate, lender: _schemas.Lender
):
    existing_pendanaan = get_pendanaan_by_lender(
        db=db, lender_id=lender.id, market_id=pendanaan.market_id
    )

    if existing_pendanaan:
        existing_pendanaan.total_pinjaman += pendanaan.total_pinjaman
        db.commit()
        db.refresh(existing_pendanaan)
    else:
        db_pendanaan = _models.Pendanaan(
            total_pinjaman=pendanaan.total_pinjaman,
            market_id=pendanaan.market_id,
            lender_id=lender.id,
            status=pendanaan.status,
        )
        db.add(db_pendanaan)
        db.commit()
        db.refresh(db_pendanaan)

    existing_market = get_market_by_id(db=db, market_id=pendanaan.market_id)

    existing_ajuan = get_ajuan_by_id(db=db, ajuan_id=existing_market.ajuan_id)
    bulat = (
        pendanaan.total_pinjaman * existing_ajuan.tenor_pendanaan / 100
    ) + pendanaan.total_pinjaman
    rounded = round(bulat)
    existing_ajuan.sisa_pengembalian += rounded
    print(existing_ajuan.sisa_pengembalian)
    db.commit()
    db.refresh(existing_ajuan)

    existing_borrower = get_borrower_by_id(
        db=db, borrower_id=existing_ajuan.borrower_id
    )

    notif_pendanaan(
        db=db,
        borrower_id=existing_borrower.id,
        lender_id=lender.id,
        dana=pendanaan.total_pinjaman,
    )

    existing_umkm = get_umkm_by_borrower(db=db, borrower_id=existing_borrower.id)

    kurang_dana_lender(
        db=db,
        lender_id=lender.id,
        dana=pendanaan.total_pinjaman,
        nama=existing_umkm.nama,
    )

    if (
        existing_market.dana_terkumpul + pendanaan.total_pinjaman
        == existing_ajuan.besar_biaya
    ):
        existing_market.status = "donpenggalangan"
        db.commit()
        db.refresh(existing_market)

        notif_dana_full(db=db, borrower_id=existing_borrower.id)

    tambah_dana_terkumpul(db=db, market=existing_market, dana=pendanaan.total_pinjaman)

    tambah_saku_borrower(
        db=db,
        borrower=existing_borrower,
        dana=pendanaan.total_pinjaman,
        nama=lender.nama,
    )

    return db_pendanaan


def get_market_by_ajuan(db: _orm.Session, ajuan_id: int):
    return db.query(_models.Market).filter(_models.Market.ajuan_id == ajuan_id).first()


def get_pendana_by_market(db: _orm.Session, market_id: int):
    return db.query(_models.Pendanaan).filter(_models.Pendanaan.market_id == market_id)


def lender_kembali(
    db: _orm.Session, lender_id: int, bunga: int, pinjam: int, borrower_id: int
):
    existing_lender = get_lender_by_id(db=db, lender_id=lender_id)
    existing_umkm = get_umkm_by_borrower(db=db, borrower_id=borrower_id)
    db_activity = _models.ActivityLender(
        lender_id=existing_lender.id,
        keterangan="Mendapatkan dana dari UMKM " + existing_umkm.nama,
        status="penerimaan",
        biaya=pinjam + (pinjam * bunga / 100),
    )
    db.add(db_activity)
    db.commit()
    db.refresh(db_activity)

    existing_lender.saku += pinjam + (pinjam * bunga / 100)
    db.commit()
    db.refresh(existing_lender)


def pengembalian(db: _orm.Session, ajuan_id: int, bunga: int, borrower_id: int):
    existing_umkm = get_umkm_by_borrower(db=db, borrower_id=borrower_id)
    existing_market = get_market_by_ajuan(db=db, ajuan_id=ajuan_id)
    existing_market.status = "selesai"
    db.commit()
    db.refresh(existing_market)

    existing_pendana = get_pendana_by_market(db=db, market_id=existing_market.id)
    for data in existing_pendana:
        lender_kembali(
            db=db,
            lender_id=data.lender_id,
            bunga=bunga,
            pinjam=data.total_pinjaman,
            borrower_id=borrower_id,
        )

        db_notif = _models.NotifikasiLender(
            lender_id=data.lender_id,
            title="Mitra Anda Telah Mengembalikan Dana",
            deskripsi="UMKM "
            + existing_umkm.nama
            + " telah mengembalikan dana pinjamannya. Silahkan cek aktivitas anda",
            status="belum",
        )
        db.add(db_notif)
        db.commit()
        db.refresh(db_notif)

        data.status = "sudah"
        db.commit()
        db.refresh(data)


def bayar_pinjaman(db: _orm.Session, m: _schemas.AjuanPatch, id: int):
    existing_ajuan = get_ajuan_by_id(db=db, ajuan_id=id)

    if existing_ajuan:
        if m.sisa_pengembalian != -9999:
            existing_ajuan.sisa_pengembalian -= m.sisa_pengembalian

        db.commit()
        db.refresh(existing_ajuan)
    else:
        raise _fastapi.HTTPException(status_code=404, detail="Item Not Found")

    existing_borrower = get_borrower_by_ajuan_id(db=db, ajuan_id=id)
    db_activity = _models.ActivityBorrower(
        borrower_id=existing_borrower.id,
        keterangan="Pembayaran kepada para pendana",
        status="pembayaran",
        biaya=m.sisa_pengembalian,
    )
    db.add(db_activity)
    db.commit()
    db.refresh(db_activity)

    if existing_ajuan.sisa_pengembalian == 0:
        existing_borrower.status = "selesai"
        db.commit()
        db.refresh(existing_borrower)

        existing_ajuan.status = "selesai"
        db.commit()
        db.refresh(existing_ajuan)

        pengembalian(
            db=db,
            ajuan_id=existing_ajuan.id,
            bunga=existing_ajuan.bunga,
            borrower_id=existing_borrower.id,
        )

    return m


def get_current_borrower_activity(db: _orm.Session, borrower: _schemas.Borrower):
    activity = db.query(_models.ActivityBorrower).filter_by(borrower_id=borrower.id)

    return list(map(_schemas.ActivityBorrower.from_orm, activity))


def get_current_lender_activity(db: _orm.Session, lender: _schemas.Lender):
    activity = db.query(_models.ActivityLender).filter_by(lender_id=lender.id)

    return list(map(_schemas.ActivityLender.from_orm, activity))


def get_borrower_pendana(db: _orm.Session, id: int):
    pendana = db.query(_models.Pendanaan).filter_by(market_id=id)
    return list(map(_schemas.Pendanaan.from_orm, pendana))


def get_current_borrower_notifikasi(db: _orm.Session, borrower: _schemas.Borrower):
    notifikasi = db.query(_models.NotifikasiBorrower).filter_by(borrower_id=borrower.id)

    return list(map(_schemas.NotifikasiBorrower.from_orm, notifikasi))


def get_current_lender_notifikasi(db: _orm.Session, lender: _schemas.Lender):
    notifikasi = db.query(_models.NotifikasiLender).filter_by(lender_id=lender.id)

    return list(map(_schemas.NotifikasiLender.from_orm, notifikasi))


def update_borrower_notifikasi(db: _orm.Session, borrower: _schemas.Borrower):
    print(borrower.id)
    existing_notifikasi = db.query(_models.NotifikasiBorrower).filter_by(
        borrower_id=borrower.id
    )

    for notifikasi in existing_notifikasi:
        notifikasi.status = "sudah"
        db.commit()
        db.refresh(notifikasi)
    return "berhasil"


def update_lender_notifikasi(db: _orm.Session, lender: _schemas.Lender):
    existing_notifikasi = db.query(_models.NotifikasiLender).filter_by(
        lender_id=lender.id
    )
    for notifikasi in existing_notifikasi:
        notifikasi.status = "sudah"
        db.commit()
        db.refresh(notifikasi)
    return "berhasil"


def get_lender_pendana(db: _orm.Session, lender: _schemas.Lender):
    pendana = db.query(_models.Pendanaan).filter(
        _models.Pendanaan.lender_id == lender.id, _models.Pendanaan.status == "belum"
    )
    return list(map(_schemas.Pendanaan.from_orm, pendana))


# def delete_current_borrower(db: _orm.Session, borrower: _schemas.Borrower):
#     return db.query(_models.Borrower).filter(
#         _models.Borrower.id == borrower.id, _models.Borrower.status == "selesai"
#     )
#     if existing_borrower:
#         print("masuk")
#         # existing_borrower.delete()
#         # db.commit()
#         # db.refresh(existing_borrower)
#     else:
#         print("masuk sini")
#         raise _fastapi.HTTPException(
#             status_code=401, detail="Anda tidak dapat menghapus akun"
#         )
