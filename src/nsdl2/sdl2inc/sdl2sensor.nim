##  Sensor event definitions.
##
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

type
  Sensor* = ptr object
    ##  Sensor.

  SensorID* = distinct int32
    ##  Sensor unique ID.
    ##
    ##  The ID starts at 0. Invalid ID has value -1.

func `==`*(a: SensorID, b: int32): bool {.borrow.}

type
  SensorType* {.size: cint.sizeof.} = enum
    ##  Sensor types.
    SDL_SENSOR_INVALID  = -1  ##  Returned for an invalid sensor.
    SDL_SENSOR_UNKNOWN        ##  Unknown sensor type.
    SDL_SENSOR_ACCEL          ##  Accelerometer.
    SDL_SENSOR_GYRO           ##  Gyroscope.
    SDL_SENSOR_ACCEL_L        ##  Accelerometer for left Joy-Con controller
                              ##  and Wii nunchuk.
    SDL_SENSOR_GYRO_L         ##  Gyroscope for left Joy-Con controller.
    SDL_SENSOR_ACCEL_R        ##  Accelerometer for right Joy-Con contrller.
    SDL_SENSOR_GYRO_R         ##  Gyroscope for right Joy-Con controller.

const
  STANDARD_GRAVITY* = cfloat 9.80665

# vim: set sts=2 et sw=2:
