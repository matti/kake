FROM ubuntu:24.04

RUN set -eux ; \
  apt-get update ; \
  apt-get upgrade -y

RUN set -eux ; \
  apt-get update ; \
  apt-get install -y --no-install-recommends \
  git ca-certificates

RUN set -eux ; \
  apt-get update ; \
  apt-get install -y --no-install-recommends \
  meson build-essential cmake scdoc \
  libwlroots-dev

RUN set -eux ; \
  mkdir /ghjk ; cd /ghjk ; \
  git clone https://github.com/cage-kiosk/cage.git ; \
  cd cage ; \
  meson build -Dxwayland=enabled --buildtype=release ; \
  ninja -C build ; \
  cp build/cage /usr/local/bin ; \
  rm -rf /ghjk

# wlclock
RUN set -eux ; \
  apt-get update ; \
  apt-get install -y --no-install-recommends \
  libgtkmm-3.0-dev

RUN set -eux ; \
  mkdir /ghjk ; cd /ghjk ; \
  git clone https://github.com/depau/wlclock.git ; \
  mkdir wlclock/build ; cd wlclock/build ; \
  cmake .. ; \
  make -j$(nproc) ; \
  cp wlclock /usr/local/bin ; \
  rm -rf /ghjk

# wayvnc
RUN set -eux ; \
  apt-get update ; \
  apt-get install -y --no-install-recommends \
  wayvnc xwayland

ENV XDG_RUNTIME_DIR="/tmp"
ENV WLR_HEADLESS_OUTPUTS=1
ENV WLR_BACKENDS=headless
ENV WLR_LIBINPUT_NO_DEVICES=1


ENV PROMPT_COMMAND="history -a"

COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
