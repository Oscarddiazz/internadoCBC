from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app import schemas, models
from app.database import get_db

router = APIRouter()

@router.post("/", response_model=schemas.EntregaComida)
def create_entrega_comida(entrega_comida: schemas.EntregaComidaCreate, db: Session = Depends(get_db)):
    db_entrega = models.EntregaComida(**entrega_comida.dict())
    db.add(db_entrega)
    db.commit()
    db.refresh(db_entrega)
    return db_entrega

@router.get("/", response_model=List[schemas.EntregaComida])
def read_entrega_comidas(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    entregas = db.query(models.EntregaComida).offset(skip).limit(limit).all()
    return entregas

@router.get("/{entcom_id}", response_model=schemas.EntregaComida)
def read_entrega_comida(entcom_id: int, db: Session = Depends(get_db)):
    db_entrega = db.query(models.EntregaComida).filter(models.EntregaComida.entcom_id == entcom_id).first()
    if db_entrega is None:
        raise HTTPException(status_code=404, detail="Entrega Comida not found")
    return db_entrega

@router.put("/{entcom_id}", response_model=schemas.EntregaComida)
def update_entrega_comida(entcom_id: int, entrega_comida: schemas.EntregaComidaCreate, db: Session = Depends(get_db)):
    db_entrega = db.query(models.EntregaComida).filter(models.EntregaComida.entcom_id == entcom_id).first()
    if db_entrega is None:
        raise HTTPException(status_code=404, detail="Entrega Comida not found")
    for key, value in entrega_comida.dict().items():
        setattr(db_entrega, key, value)
    db.commit()
    db.refresh(db_entrega)
    return db_entrega

@router.delete("/{entcom_id}")
def delete_entrega_comida(entcom_id: int, db: Session = Depends(get_db)):
    db_entrega = db.query(models.EntregaComida).filter(models.EntregaComida.entcom_id == entcom_id).first()
    if db_entrega is None:
        raise HTTPException(status_code=404, detail="Entrega Comida not found")
    db.delete(db_entrega)
    db.commit()
    return {"detail": "Entrega Comida deleted"}