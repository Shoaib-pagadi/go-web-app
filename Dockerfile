# first stage
#download a base image and create an alias for the stage 1
FROM golang:1.22 as base  

#create a workdir
WORKDIR /app

#depenedencies for go are stored in go.mod file it is same as requirement.txt
COPY go.mod .

# this downloads the dependendeies for application its same as pip install requirement.txt
RUN go mod download

#copying whole source code to image
COPY . .

# RUn the command to build a binary 'main'
RUN go build -o main .

# final stage with ditroless image
# use distroless image
FROM gcr.io/distroless/base

#copy the created binary which is created in base stage here it is 'main'
COPY --from=base /app/main .

# copy the static content from base stage
COPY --from=base /app/static ./static

#expose the port
EXPOSE 8080

#execute the binary which is created
CMD ["/main"]