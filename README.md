# SLS (SRT live server)
Dockerized version of Edward Wu's SRT Live Server (SLS) and Haivision's SRT SDK
All credit should go to the original tool author(s) - this is just a dockerization for convenience and portability.

### Requirements:
- [`Docker 24.x or later`](https://www.docker.com)

To build, just execute the script `build.sh`.

To deploy in Akamai Connected Cloud, just execute the script `deploy.sh`.

### Deployment settings:
You can customize your deployment by editing the file `iac/settings.json`. If the file doesn't exist, just create it
using the content of the template `iac/settings.json.template`. You also will need to set up the credentials of the 
Akamai Connected Cloud in the file `iac/.credentials`. If the file doesn't exist, just create it using the content of
the template `iac/.credentials.template`. Go to the Akamai Cloud Manager, create your API credential and then update 
the `iac/.credentials` file. 

### Streaming settings:
* Default listen port is `1935/UDP`. Note that SRT doesn't technically have a default protocol port, so you will have to 
explicitly call this out in stream URLs (see below). `1935/TCP` is what RTMP uses, so this makes it simpler to remember.
* Default latency is `200ms`. (Nimble Streamer recommended no lower than `120ms` no matter what, Haivision can do lower 
on hardware). If your streams are getting "confetti" you may want to set this higher, but I've found this to be a safe 
default in using OBS and Larix SRT streams over a reasonable internet connection. Think of this as a "safety buffer" 
for connection burps.
* There are two "endpoints", a publisher and an application. 
* Publishing is for sending, application is for receiving/play. 
* They are "stream/live" and "play/live", respectively. I changed them from the author's defaults to make them a bit 
less confusing.

If you want to customize the settings, just specify the following environment variables in the `iac/docker-compose.yml`:
- `LATENCY (Default 200)`
- `THREADS (Default 2)`
- `CONNECTIONS (Default 300)`
- `BACKLOG (Default 100)`
- `IDLE_TIMEOUT (Default 60)`
- `LISTEN_PORT (Default 1935)`

Example Sending of SRT in OBS:
* In the setup menu under "stream", select "Custom..."  leave the Stream Key field blank.
* Put the following url: `srt://<your.server.ip>:1935?streamid=stream/live/<yourstreamname>`.

Example of Receiving of SRT in OBS:
* Add a Media Source.
* Put the following url to receive: `srt://<your.server.ip>:1935?streamid=play/live/<yourstreamname>`.

### References:
- https://github.com/Edward-Wu/srt-live-server
- https://blog.wmspanel.com/2019/06/srt-latency-maxbw-efficient-usage.html
- https://www.haivision.com/blog/all/how-to-configure-srt-settings-video-encoder-optimal-performance/