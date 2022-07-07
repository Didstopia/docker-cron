![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/didstopia/cron?label=Docker%20Hub%20Build&style=for-the-badge)

# Cron - Scheduled Container Tasks

The ideal base image for cronjob based containers.

## Usage

_Note that the intended use case for this image is to use it as a base image!_

Basic usage example:

```sh
docker run \
    -e TZ="Europe/Helsinki" \
    -e SCRIPT_SCHEDULE="everyminute" \
    -e SCRIPT_WORKING_DIRECTORY="\/data" \
    -e SCRIPT_STARTUP_COMMAND=".\/script.sh" \
    -v $(pwd)/sample_script.sh:/data/script.sh \
    --name cron \
    -it \
    --rm \
    didstopia/cron:latest
```

See [Dockerfile] for further options.

## Scheduling

The built-in scheduler can be configured by simply setting `SCRIPT_SCHEDULE` to any of the following string values:

- `everyminute`
- `15min`
- `hourly`
- `daily`
- `weekly`
- `monthly`

## Known Issues

- [ ] Cron should ideally log output to both a file and to `/dev/stdout`, and this should be user configurable
- [ ] Time zone should be taken into account in cron logs (eg. when setting `TZ="Europe/Helsinki"`)
- [ ] Users should not have to escape slashes in environment variables (eg. when using `SCRIPT_WORKING_DIRECTORY` or `SCRIPT_STARTUP_COMMAND`)

## License

See [LICENSE](LICENSE).
