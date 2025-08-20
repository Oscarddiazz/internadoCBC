from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app import schemas, models
from app.database import get_db

router = APIRouter()

@router.post("/", response_model=schemas.Tarea)
def create_tarea(tarea: schemas.TareaCreate, db: Session = Depends(get_db)):
    db_tarea = models.Tarea(**tarea.dict())
    db.add(db_tarea)
    db.commit()
    db.refresh(db_tarea)
    return db_tarea

@router.get("/", response_model=List[schemas.Tarea])
def read_tareas(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    tareas = db.query(models.Tarea).offset(skip).limit(limit).all()
    return tareas

@router.get("/{tarea_id}", response_model=schemas.Tarea)
def read_tarea(tarea_id: int, db: Session = Depends(get_db)):
    db_tarea = db.query(models.Tarea).filter(models.Tarea.tarea_id == tarea_id).first()
    if db_tarea is None:
        raise HTTPException(status_code=404, detail="Tarea not found")
    return db_tarea

@router.put("/{tarea_id}", response_model=schemas.Tarea)
def update_tarea(tarea_id: int, tarea: schemas.TareaCreate, db: Session = Depends(get_db)):
    db_tarea = db.query(models.Tarea).filter(models.Tarea.tarea_id == tarea_id).first()
    if db_tarea is None:
        raise HTTPException(status_code=404, detail="Tarea not found")
    for key, value in tarea.dict().items():
        setattr(db_tarea, key, value)
    db.commit()
    db.refresh(db_tarea)
    return db_tarea

@router.delete("/{tarea_id}")
def delete_tarea(tarea_id: int, db: Session = Depends(get_db)):
    db_tarea = db.query(models.Tarea).filter(models.Tarea.tarea_id == tarea_id).first()
    if db_tarea is None:
        raise HTTPException(status_code=404, detail="Tarea not found")
    db.delete(db_tarea)
    db.commit()
    return {"detail": "Tarea deleted"}