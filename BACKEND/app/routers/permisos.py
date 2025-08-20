from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app import schemas, models
from app.database import get_db

router = APIRouter()

@router.post("/", response_model=schemas.Permiso)
def create_permiso(permiso: schemas.PermisoCreate, db: Session = Depends(get_db)):
    db_permiso = models.Permiso(**permiso.dict())
    db.add(db_permiso)
    db.commit()
    db.refresh(db_permiso)
    return db_permiso

@router.get("/", response_model=List[schemas.Permiso])
def read_permisos(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    permisos = db.query(models.Permiso).offset(skip).limit(limit).all()
    return permisos

@router.get("/{permiso_id}", response_model=schemas.Permiso)
def read_permiso(permiso_id: int, db: Session = Depends(get_db)):
    db_permiso = db.query(models.Permiso).filter(models.Permiso.permiso_id == permiso_id).first()
    if db_permiso is None:
        raise HTTPException(status_code=404, detail="Permiso not found")
    return db_permiso

@router.put("/{permiso_id}", response_model=schemas.Permiso)
def update_permiso(permiso_id: int, permiso: schemas.PermisoCreate, db: Session = Depends(get_db)):
    db_permiso = db.query(models.Permiso).filter(models.Permiso.permiso_id == permiso_id).first()
    if db_permiso is None:
        raise HTTPException(status_code=404, detail="Permiso not found")
    for key, value in permiso.dict().items():
        setattr(db_permiso, key, value)
    db.commit()
    db.refresh(db_permiso)
    return db_permiso

@router.delete("/{permiso_id}")
def delete_permiso(permiso_id: int, db: Session = Depends(get_db)):
    db_permiso = db.query(models.Permiso).filter(models.Permiso.permiso_id == permiso_id).first()
    if db_permiso is None:
        raise HTTPException(status_code=404, detail="Permiso not found")
    db.delete(db_permiso)
    db.commit()
    return {"detail": "Permiso deleted"}