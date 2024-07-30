FROM rocker/r-ver:4.4.1

RUN apt-get update -qq && apt-get install -y libssl-dev libcurl4-gnutls-dev

RUN R -e "install.packages('GGally')"
RUN R -e "install.packages('plumber')"


RUN mkdir /app
COPY myAPI.R /app/
COPY myAPI.R myAPI.R

COPY diabetes_binary_health_indicators_BRFSS2015.csv /app/


EXPOSE 8000

ENTRYPOINT ["R", "-e", "pr <- plumber::plumb('/usr/local/myapp/myAPI.R'); pr$run(host='0.0.0.0', port=8000)"]
