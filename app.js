const express = require('express');
const app = express();
const server = require('http').Server(app);
const io = require('socket.io')(server);
const stream = require('./ws/stream');
const path = require('path');
const { mainModule } = require('process');
const PORT = process.env.PORT || 3000;

app.use('/assets', express.static(path.join(__dirname, 'assets')));

app.get('/', (req, res) => {
	res.sendFile(__dirname + '/index.html');
});

io.of('/stream').on('connection', stream);

function Main() {
	try {
		server.listen(PORT, () => {
			console.log(`Server started on port: ${PORT}`);
		});
	} catch (err) {
		console.log(err);
	}
}
Main();
