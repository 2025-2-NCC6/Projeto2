// udp_server.js
const dgram = require("dgram");

// Create a UDP socket
const server = dgram.createSocket("udp4");

// Configuration
const LISTEN_PORT = 41234; // port to listen on
const LISTEN_HOST = "0.0.0.0"; // listen on all network interfaces

const TARGET_PORT = 5000; // port of the other device
const TARGET_HOST = "121.128.1.100"; // IP of the other device

// When a message is received
server.on("message", (msg, rinfo) => {
  console.log(`Received message: ${msg} from ${rinfo.address}:${rinfo.port}`);

  // Example: Send a reply to another device
  const message = Buffer.from("Hello from UDP server!");
  server.send(message, 0, message.length, TARGET_PORT, TARGET_HOST, (err) => {
    if (err) {
      console.error("Error sending message:", err);
    } else {
      console.log(`Message sent to ${TARGET_HOST}:${TARGET_PORT}`);
    }
  });
});

// Handle server startup
server.on("listening", () => {
  const address = server.address();
  console.log(`UDP server listening on ${address.address}:${address.port}`);
});

// Handle errors
server.on("error", (err) => {
  console.error(`Server error:\n${err.stack}`);
  server.close();
});

// Start listening
server.bind(LISTEN_PORT, LISTEN_HOST);
