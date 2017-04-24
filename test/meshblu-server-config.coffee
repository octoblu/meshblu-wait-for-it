class MeshbluServerConfig
  constructor: (@name) ->
    throw new Error 'MeshbluServerConfig: requires name' unless @name?

  toJSON: =>
    dispatcherWorker:
      namespace:           "test-wait-for-it-#{@name}"
      requestQueueName:    "test-wait-for-it-request-queue-#{@name}"
      timeoutSeconds:      1
      redisUri:            'redis://localhost:6379'
      cacheRedisUri:       'redis://localhost:6379'
      firehoseRedisUri:    'redis://localhost:6379'
      mongoDBUri:          "mongodb://localhost:27017/test-wait-for-it-meshblu-#{@name}"
      pepper:              'random-string'
      workerName:          'test'
      aliasServerUri:      ''
      jobLogRedisUri:      'redis://localhost:6379'
      jobLogQueue:         'job-log:sample-rate:0'
      jobLogSampleRate:    0
      privateKey:          'LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBaGxPcFZoWXIrMzdtNERxMzlxU0JRblpFcVdpaUZDQTh6MHVLNUpsdSsvWDk2Qzl0CmJBY0s5UC9xaEQ1SjlVUHQ3T1BTbEV4R2FTYk5LdmtRWTc1N3d0Z0ljb3ZDWU5VLy9wNHBGVDkwS3BPWU91WS8KaDhnQWdVa2NCaVY3am5LSzltL2ttaC83WE1Id3hRc0h4N3h2QWViVzRMdE5IUjRWMlVRZjB3Y0hJTFg4SDFyNAozbmk4ZExCWlduWC91QlZRaWk4VW5zVUE1Skt1bUVZd0hyWHVkd0RkSk9XR1o5S1Y4cC9kMVJmNnJIWS9EQnlMCnM5QTlsR3pKQ2s3ZGhNNjBzcjgrdXdvTUNlU3ZLZnlpZi96K0N3aTY0YVZhd2ZNN2tNN2FoMk5iS2ZqNElFQU0Kc2tWdk15WUdLWkZlTXZNSjZvLzN0Z1B4bW92Y3dMR3NFNWx6QndJREFRQUJBb0lCQUh3VkxqaUtsS2htS21sNQpkRlJPMCtTTUVaTVlSNWdseTJhRjF0Q2lkMllpYnlDYkp3NENWM25JS1Y5dGxxNE15T3pwNnF6NDVKWGZ0T2g4CldFcDdQQ0habzd3RUpGT0V5ZSt2TkM0ZmhuU0tFTFpmMk5IWnk3V2h6bFJUTFphQmNxS0E2Ly8vaVJlL1EyVVIKY21kc1JuTFFSVEFsZE85dnlpa0FDQkhNelNYRi8waEkwSUptcjAzN0Uyc1RCSURKMmd0M0FtNlBKaWNVaEtZNQpiVGw0ZHRqSEc1WE9UVmlEMTRjQU5ZN1dYSEVwNEJsdEJkWGQ4Y3lSdmhpczYzaVFSNFRDYjl1WGgvdG5lczU4CmNkdUhiOGlhYzBlZGhvclZNUU5mL0daTTFmMUd2dC9oVklYdmd2c2RmNHcyMDFSTG0wNEh0RHQrVHlrUFJRdUcKNyt5NWY3RUNnWUVBd0FTdDJnK0xMWnkvN3pUVnlweXUrMWgrRWd2aVVLMytFRnBJOWJ6cjRkc3A5R2pJbFBkMAo3cTNUcU5qWHN3NTZMQzB4RkwxSVBKRHBnTGVLRjJCbUNlWkJ6SmRET0Q0MGc1WkZxSUZYV1RNZEVzT2NjTzg2Ci9GZEZlYnVPa0VVYUYxbTNGejA4dVNRdElzcE9Bc0t2cytxdTgwdmJVbE9aQkVhUEo4RlB5djhDZ1lFQXN4WFoKMWRRd0I2TWJ6c0poajdVUmhOVkQxWjdacHlJZGVOWWFWekpYTHk1d2hNR3JobXVZVjlJc0I5eGxsR3FLbTlMZwpRTnljUXNBbTR5VnJrKzNJcVgzeFI0bzRFSS9pWFI3UDFlTFp4eW5KYWRIMUhURU15N3VmblF1VDJ4RjR1OUJ4CklmclVUQXI0U083N1RXdUJpN1NOc0tUS2o1ZG0waWYwYXdzMy8va0NnWUVBaElMMkl4VTAvQjQvaW1tUTNJa3kKYkh4T1RFL3RON1pMTGFmUXo5MDNmNThLbmdPdDRMZkE5M0g0TG42dXBIL3FLaEJwM2FFZWQ4V2RqdG1hcjdVegoxY01VUjRkZnVUR2NkZTYvVmFFazBZYm5tbXBwekxvYm44YnVTQ3I2SUcrL3FMdWVFYWlOL2txTDU0VnJQcFp5ClFKeEZiZHM4bU56ZUxVZ3dSTVF3TjZzQ2dZQlVtR2ZVV0cxdnpoN2VwbmZMbUs3ejNvSXlzTjBEMUZ1enJ2KzIKWFBOT09GT3lnb0h4OTNWNVZyQ3g3ZXlXRlZYd2tjYVpIUjA3Y3VWcnUwdDhENEVRZjR1d1RaeDZSbDJadTJwVwpFTmpxK2RSSkJvTVJEUkNNVk03ck1vTGZvdnN6VFIyRC9hYTNYUjgzNUp3VlVFbGJveWlqWHRUSXk2NG9hL05MCmRYczRrUUtCZ0JPWmFpMFg0VmpLRjF6Wm9jUzF6eHcvUVYrQnRjTnVmb2ViV0JqdVd4SFdrZ1Z5cFJpNWMyNCsKZGJ5elJyMmx0ejhHYndhbmVGNUpOVVJnT1ZDR0YwYTAyYWtxUGMxRWxXZWlRY05iVFFqWmtDSERlbXF5aGxQaAoyT3VWWUdPNDdQK3VEM1pZOW9qMElkSmJ1WTZidjVqVGx3OGpMSnBRcm5sZWtmS05VMHdTCi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg=='
      publicKey:           'LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS1cbk1JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBTUlJQkNnS0NBUUVBaGxPcFZoWXIrMzdtNERxMzlxU0JcblFuWkVxV2lpRkNBOHowdUs1Smx1Ky9YOTZDOXRiQWNLOVAvcWhENUo5VVB0N09QU2xFeEdhU2JOS3ZrUVk3NTdcbnd0Z0ljb3ZDWU5VLy9wNHBGVDkwS3BPWU91WS9oOGdBZ1VrY0JpVjdqbktLOW0va21oLzdYTUh3eFFzSHg3eHZcbkFlYlc0THROSFI0VjJVUWYwd2NISUxYOEgxcjQzbmk4ZExCWlduWC91QlZRaWk4VW5zVUE1Skt1bUVZd0hyWHVcbmR3RGRKT1dHWjlLVjhwL2QxUmY2ckhZL0RCeUxzOUE5bEd6SkNrN2RoTTYwc3I4K3V3b01DZVN2S2Z5aWYveitcbkN3aTY0YVZhd2ZNN2tNN2FoMk5iS2ZqNElFQU1za1Z2TXlZR0taRmVNdk1KNm8vM3RnUHhtb3Zjd0xHc0U1bHpcbkJ3SURBUUFCXG4tLS0tLUVORCBQVUJMSUMgS0VZLS0tLS0='
      singleRun:           false
      concurrency:         1
    meshbluHttp:
      redisUri:              'redis://localhost:6379'
      cacheRedisUri:         'redis://localhost:6379'
      requestQueueName:      "test-wait-for-it-request-queue-#{@name}"
      responseQueueName:     "test-wait-for-it-response-queue-#{@name}"
      namespace:             "test-wait-for-it-#{@name}"
      jobLogRedisUri:        'redis://localhost:6379'
      jobLogQueue:           'job-log:sample-rate:0'
      jobLogSampleRate:      0
      jobTimeoutSeconds:     60
      maxConnections:        5
      port:                  @port()
    webhookWorker:
      namespace:           "test-wait-for-it-#{@name}"
      redisUri:            'redis://localhost:6379'
      queueName:           "test-wait-for-it-webhook-queue-#{@name}"
      queueTimeout:        1
      requestTimeout:      15
      jobLogRedisUri:      'redis://localhost:6379'
      jobLogQueue:         'job-log:sample-rate:0'
      jobLogSampleRate:    0
      privateKey:          'LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBaGxPcFZoWXIrMzdtNERxMzlxU0JRblpFcVdpaUZDQTh6MHVLNUpsdSsvWDk2Qzl0CmJBY0s5UC9xaEQ1SjlVUHQ3T1BTbEV4R2FTYk5LdmtRWTc1N3d0Z0ljb3ZDWU5VLy9wNHBGVDkwS3BPWU91WS8KaDhnQWdVa2NCaVY3am5LSzltL2ttaC83WE1Id3hRc0h4N3h2QWViVzRMdE5IUjRWMlVRZjB3Y0hJTFg4SDFyNAozbmk4ZExCWlduWC91QlZRaWk4VW5zVUE1Skt1bUVZd0hyWHVkd0RkSk9XR1o5S1Y4cC9kMVJmNnJIWS9EQnlMCnM5QTlsR3pKQ2s3ZGhNNjBzcjgrdXdvTUNlU3ZLZnlpZi96K0N3aTY0YVZhd2ZNN2tNN2FoMk5iS2ZqNElFQU0Kc2tWdk15WUdLWkZlTXZNSjZvLzN0Z1B4bW92Y3dMR3NFNWx6QndJREFRQUJBb0lCQUh3VkxqaUtsS2htS21sNQpkRlJPMCtTTUVaTVlSNWdseTJhRjF0Q2lkMllpYnlDYkp3NENWM25JS1Y5dGxxNE15T3pwNnF6NDVKWGZ0T2g4CldFcDdQQ0habzd3RUpGT0V5ZSt2TkM0ZmhuU0tFTFpmMk5IWnk3V2h6bFJUTFphQmNxS0E2Ly8vaVJlL1EyVVIKY21kc1JuTFFSVEFsZE85dnlpa0FDQkhNelNYRi8waEkwSUptcjAzN0Uyc1RCSURKMmd0M0FtNlBKaWNVaEtZNQpiVGw0ZHRqSEc1WE9UVmlEMTRjQU5ZN1dYSEVwNEJsdEJkWGQ4Y3lSdmhpczYzaVFSNFRDYjl1WGgvdG5lczU4CmNkdUhiOGlhYzBlZGhvclZNUU5mL0daTTFmMUd2dC9oVklYdmd2c2RmNHcyMDFSTG0wNEh0RHQrVHlrUFJRdUcKNyt5NWY3RUNnWUVBd0FTdDJnK0xMWnkvN3pUVnlweXUrMWgrRWd2aVVLMytFRnBJOWJ6cjRkc3A5R2pJbFBkMAo3cTNUcU5qWHN3NTZMQzB4RkwxSVBKRHBnTGVLRjJCbUNlWkJ6SmRET0Q0MGc1WkZxSUZYV1RNZEVzT2NjTzg2Ci9GZEZlYnVPa0VVYUYxbTNGejA4dVNRdElzcE9Bc0t2cytxdTgwdmJVbE9aQkVhUEo4RlB5djhDZ1lFQXN4WFoKMWRRd0I2TWJ6c0poajdVUmhOVkQxWjdacHlJZGVOWWFWekpYTHk1d2hNR3JobXVZVjlJc0I5eGxsR3FLbTlMZwpRTnljUXNBbTR5VnJrKzNJcVgzeFI0bzRFSS9pWFI3UDFlTFp4eW5KYWRIMUhURU15N3VmblF1VDJ4RjR1OUJ4CklmclVUQXI0U083N1RXdUJpN1NOc0tUS2o1ZG0waWYwYXdzMy8va0NnWUVBaElMMkl4VTAvQjQvaW1tUTNJa3kKYkh4T1RFL3RON1pMTGFmUXo5MDNmNThLbmdPdDRMZkE5M0g0TG42dXBIL3FLaEJwM2FFZWQ4V2RqdG1hcjdVegoxY01VUjRkZnVUR2NkZTYvVmFFazBZYm5tbXBwekxvYm44YnVTQ3I2SUcrL3FMdWVFYWlOL2txTDU0VnJQcFp5ClFKeEZiZHM4bU56ZUxVZ3dSTVF3TjZzQ2dZQlVtR2ZVV0cxdnpoN2VwbmZMbUs3ejNvSXlzTjBEMUZ1enJ2KzIKWFBOT09GT3lnb0h4OTNWNVZyQ3g3ZXlXRlZYd2tjYVpIUjA3Y3VWcnUwdDhENEVRZjR1d1RaeDZSbDJadTJwVwpFTmpxK2RSSkJvTVJEUkNNVk03ck1vTGZvdnN6VFIyRC9hYTNYUjgzNUp3VlVFbGJveWlqWHRUSXk2NG9hL05MCmRYczRrUUtCZ0JPWmFpMFg0VmpLRjF6Wm9jUzF6eHcvUVYrQnRjTnVmb2ViV0JqdVd4SFdrZ1Z5cFJpNWMyNCsKZGJ5elJyMmx0ejhHYndhbmVGNUpOVVJnT1ZDR0YwYTAyYWtxUGMxRWxXZWlRY05iVFFqWmtDSERlbXF5aGxQaAoyT3VWWUdPNDdQK3VEM1pZOW9qMElkSmJ1WTZidjVqVGx3OGpMSnBRcm5sZWtmS05VMHdTCi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg=='
      meshbluConfig:
        uuid: 'some-uuid'
        token: 'some-token'

  port: =>
    return 0xDEAD

module.exports = MeshbluServerConfig
