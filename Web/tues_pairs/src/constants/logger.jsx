const winston = require("winston");

var log = winston.createLogger({
    transports: [
      new winston.transports.Console(),
    ]
});

export default log;