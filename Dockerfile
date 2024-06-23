FROM ubuntu:24.04
ENV PROMPT_COMMAND="history -a"

COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
