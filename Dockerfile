FROM python:alpine as prepared

ENV USER "maintainer"
ENV BASE_DIR "/pkgbuild"
ENV HOME "$BASE_DIR"

RUN apk --no-cache add shadow \
        && useradd --create-home "$USER" \
        && mkdir -p "$BASE_DIR" \
        && chown "$USER:$USER"  "$BASE_DIR"

WORKDIR $BASE_DIR
USER "$USER"

COPY --chown="$USER" requirements.txt .
RUN pip install --no-cache-dir --no-warn-script-location --user -r requirements.txt

FROM prepared
COPY . .
CMD ["python", "/pkgbuild/check-aur-pkg-version"]
