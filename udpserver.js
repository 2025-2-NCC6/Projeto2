import { initializeApp } from "firebase/app";
import { getFirestore, collection, addDoc } from "firebase/firestore";

// udp_server.js
import dgram from "dgram";

// Create a UDP socket
const server = dgram.createSocket("udp4");

const firebaseConfig = {
  apiKey: "AIzaSyD9g9kp1B82YeNIKBZnSyW5_mnjSRn32qo",
  authDomain: "controlap-39602.firebaseapp.com",
  databaseURL: "https://controlap-39602-default-rtdb.firebaseio.com",
  projectId: "controlap-39602",
  storageBucket: "controlap-39602.firebasestorage.app",
  messagingSenderId: "712598597437",
  appId: "1:712598597437:web:4e92d7ca6dd80b0de79f54",
  measurementId: "G-J5E106SJQ1",
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

console.log("Firebase conectado!");

async function adicionarUsuario() {
  try {
    const docRef = await addDoc(collection(db, "usuarios"), {
      nome: "Vitor",
      idade: 25,
      email: "vitor@email.com",
    });
    console.log("Documento adicionado com ID: ", docRef.id);
  } catch (e) {
    console.error("Erro ao adicionar documento: ", e);
  }
}



// Configuration
const LISTEN_PORT = 41234; // port to listen on
const LISTEN_HOST = "0.0.0.0"; // listen on all network interfaces

const TARGET_PORT = 5000; // port of the other device
const TARGET_HOST = "192.168.15.3"; // IP of the other device

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
      adicionarUsuario();
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
