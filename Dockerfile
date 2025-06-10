# 베이스 이미지
FROM python:3.11-slim

# 작업 디렉토리 생성
WORKDIR /app

# 의존성 잠금파일 복사 (poetry.lock 과 pyproject.toml 또는 uv.lock 같은 것)
COPY uv.lock pyproject.toml /app/

# uv 설치 (uv는 poetry+uvicorn 포함된 툴)
RUN pip install uv

# 의존성 설치 (uv.lock 기준으로)
RUN uv sync

# Django 프로젝트 전체 복사
COPY . /app

# static 파일 수집 (필요 시)
RUN python manage.py collectstatic --noinput

# uv를 통해 gunicorn으로 Django 실행 (uv 지원함)
CMD ["uv", "run", "gunicorn", "app.config.wsgi:application", "--bind", "0.0.0.0:8000"]