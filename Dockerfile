FROM fuzzers/afl:2.52 as builder

RUN apt-get update
RUN apt install -y build-essential wget clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev
ADD . /inifile-cpp
WORKDIR /inifile-cpp
RUN cmake .
RUN make install
ADD fuzzers/fuzz_ini_load.cpp .
RUN afl-clang++ -I/usr/local/include fuzz_ini_load.cpp -o /fuzz_ini_load
RUN mkdir /inifile_corpus

#RUN wget http://sample-file.bazadanni.com/download/applications/ini/sample.ini
RUN wget https://raw.githubusercontent.com/grafana/grafana/main/conf/sample.ini
RUN mv *.ini /inifile_corpus/

FROM fuzzers/afl:2.52
COPY --from=builder /fuzz_ini_load /
COPY --from=builder /inifile_corpus /testsuite

ENTRYPOINT ["afl-fuzz", "-i", "/testsuite", "-o", "/inifilecppOut"]
CMD ["/fuzz_ini_load", "@@"]
