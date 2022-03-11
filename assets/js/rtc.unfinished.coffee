###
SPDX-License-Identifier: MIT
Author: Mark Gutenberger <mark-gutenberger@outlook.com>
trc.coffee (c) 2022
Desc: description
Created:  2022-03-07T14:13:31.387Z
Modified: 2022-03-11T15:03:19.408Z
###
import h from './helpers.js'

window.addEventListener 'load', => ->
	room = h.getQString location.href, 'room'
	username = sessionStorage.getItem 'username'
	if !room
		document.querySelector('#room-create').attributes.removeNamedItem 'hidden'
	else if !username
		document.querySelector('#username-set').attributes.removeNamedItem 'hidden'
	else
		commElem = document.getElementsByClassName 'room-comm'
		for i in commElem.length i++
			commElem[i].attributes.removeNamedItem 'hidden'
		#endfor
		pc = []
		socket = io '/stream'
		socketId = ''
		randomNumber = "__#{h.generateRandomString()}__#{h.generateRandomString()}__"
		myStream = ''
		screen = ''
		recordedStream = []
		mediaRecorder = ''
		getAndSetUserStream()

		socket.on 'connect', => ->
			socketId = socket.io.engine.id
			randomNumber = document.getElementById('randomNumber').innerText
			socket.emit 'subscribe', room: room, socketId: socketId
			socket.on 'new user', (data) => ->
				socket.emit 'newUserStart', to: data.socketId, sender: socketId
				pc.push data.socketId
				init true, data.socketId
			#endfunc
			socket.on 'newUserStart', (data) => ->
				pc.push data.sender
				init false, data.sender
			#endfunc
			socket.on 'ice candidates', (data) => ->
				data.candidate ? (await pc[data.sender].addIceCandidate(new RTCIceCandidate data.candidate) '')
			#endfunc
			socket.on 'sdp', (data) => ->
				if data.description.type is 'offer'
					data.description ?
						(await pc[data.sender].setRemoteDescription(new RTCSessionDescription data.description) '')
					h
						.getUserFullMedia()
						.then (stream) => ->
							if !document.getElementById('local').srcObject
								h.setLocalStream stream
							#endif

							#save my stream
							myStream = stream
							stream
								.getTracks()
								.forEach (track) => ->
									pc[data.sender].addTrack track, stream
									#endfunc
							answer = await pc[data.sender].createAnswer()
							await pc[data.sender].setLocalDescription answer
							socket.emit 'sdp',
								description: pc[data.sender].localDescription
								to: data.sender
								sender: socketId
							#endfunc
						.catch (e) => ->
							console.error e
							#endfunc
				else if data.description.type is 'answer'
					await pc[data.sender].setRemoteDescription new RTCSessionDescription data.description
				#endif
			#endfunc
			socket.on 'chat', (data) => ->
				h.addChat data, 'remote'
			#endfunc
		#endfunc

		getAndSetUserStream() ->
			h
				.getUserFullMedia()
				.then (stream) => ->
					myStream = stream
					h.setLocalStream stream
					#endfunc
				.catch (e) => ->
					console.error "stream error: #{e}"
					#endfunc
		#endfunc
		sendMsg(msg) ->
			data =
				room: room
				msg: msg
				sender: "#{username} (#{randomNumber})"

			socket.emit 'chat', data

			h.addChat data, 'local'

		init(createOffer, partnerName) ->
			pc[partnerName] = new RTCPeerConnection h.getIceServer()
			if screen and screen.getTracks().length
				screen
					.getTracks()
					.forEach (track) => ->
						pc[partnerName].addTrack track, screen #should trigger negotiationneeded event
			else if myStream
				myStream
					.getTracks()
					.forEach (track) => ->
						pc[partnerName].addTrack track, myStream #should trigger negotiationneeded event
			else
				h
					.getUserFullMedia()
					.then (stream) => ->
						#save my stream
						myStream = stream
						stream
							.getTracks()
							.forEach (track) => ->
								pc[partnerName].addTrack track, stream #should trigger negotiationneeded event

						h.setLocalStream stream
					.catch (e) => ->
						console.error "stream error: #{e}"
			#endif
			if createOffer
				pc[partnerName].onnegotiationneeded = => ->
					offer = await pc[partnerName].createOffer()

					await pc[partnerName].setLocalDescription offer

					socket.emit 'sdp', description: pc[partnerName].localDescription, to: partnerName, sender: socketId
				#endfunc
			#endif
			pc[partnerName].onicecandidate = ({ candidate }) => ->
				socket.emit 'ice candidates', candidate: candidate, to: partnerName, sender: socketId
			#endfunc
			pc[partnerName].ontrack = (e) => ->
				str = e.streams[0]
				if document.getElementById "#{partnerName}-video"
					document.getElementById("#{partnerName}-video").srcObject = str
				else
					#video elem
					newVid = document.createElement 'video'
					newVid.id = "#{partnerName}-video"
					newVid.srcObject = str
					newVid.autoplay = true
					newVid.className = 'remote-video'
					controlDiv = document.createElement 'div'
					controlDiv.className = 'remote-video-controls'
					controlDiv.innerHTML = '''
						<i class="fa fa-microphone text-white pr-3 mute-remote-mic" title="Mute"></i>
						<i class="fa fa-expand text-white expand-remote-video" title="Expand"></i>
						'''
					cardDiv = document.createElement 'div'
					cardDiv.className = 'card card-sm'
					cardDiv.id = partnerName
					cardDiv.appendChild newVid
					cardDiv.appendChild controlDiv
					document.getElementById('videos').appendChild cardDiv
					h.adjustVideoElemSize()
				#endif
			#endfunc

			pc[partnerName].onconnectionstatechange = (d) => ->
				switch pc[partnerName].iceConnectionState
					when 'disconnected' then h.closeVideo partnerName
					when 'failed' then h.closeVideo partnerName
					when 'closed' then h.closeVideo partnerName
				#endswitch
			#endfunc

			pc[partnerName].onsignalingstatechange = (d) => ->
				switch pc[partnerName].signalingState
					when 'closed'
						=> ->
							console.log "Signalling state is 'closed'"
							h.closeVideo partnerName
				#endswitch
			#endfunc
		# endfunc

		shareScreen() ->
			h
				.shareScreen()
				.then (stream) => ->
					h.toggleShareIcons true

					h.toggleVideoBtnDisabled true

					screen = stream

					broadcastNewTracks stream, 'video', false

					screen
						.getVideoTracks()[0]
						.addEventListener 'ended', => ->
							stopSharingScreen()
				.catch (e) => ->
					console.error e
		#endfunc

		stopSharingScreen() ->
			#enable video toggle btn
			h.toggleVideoBtnDisabled false

			return (
				new Promise((res, rej) => ->
					screen.getTracks().length ?
						screen
							.getTracks()
							.forEach (track) => ->
								track.stop() ''
								#endfunc
					res())
					#endfunc
					.then => ->
						h.toggleShareIcons false
						broadcastNewTracks myStream, 'video'
						#endfunc
					.catch (e) => ->
						console.error e
						#endfunc
			)
			#endfunc
		#endfunc

		broadcastNewTracks(stream, type, (mirrorMode = true)) ->
			h.setLocalStream stream, mirrorMode
			track = type == 'audio' ? (stream.getAudioTracks()[0] and stream.getVideoTracks()[0])
			for p in pc
				pName = pc[p]
				if typeof pc[pName] == 'object'
					h.replaceTrack track, pc[pName]
				#endif
			#endfor
		#endfunc

		toggleRecordingIcons(isRecording) ->
			e = document.getElementById 'record'

			if isRecording
				e.setAttribute 'title', 'Stop recording'
				e.children[0].classList.add 'text-danger'
				e.children[0].classList.remove 'text-white'
			else
				e.setAttribute 'title', 'Record'
				e.children[0].classList.add 'text-white'
				e.children[0].classList.remove 'text-danger'
			#endif
		#endfunc

		startRecording(stream) ->
			mediaRecorder = new MediaRecorder stream, mimeType: 'video/webm;codecs=vp9'

			mediaRecorder.start 1000
			toggleRecordingIcons true

			mediaRecorder.ondataavailable = (e) ->
				recordedStream.push e.data
			#endfunc
			mediaRecorder.onstop = ->
				toggleRecordingIcons false

				h.saveRecordedStream recordedStream, username

				setTimeout => -> recordedStream = []
			#endfunc

			mediaRecorder.onerror = (e) ->
				console.error e
			#endfunc
		#endfunc

		#Chat textarea
		document
			.getElementById 'chat-input'
			.addEventListener 'keypress', (e) => ->
				if e.which is 13 and e.target.value.trim()
					e.preventDefault()

					sendMsg e.target.value

					setTimeout => -> e.target.value = ''
					#endif
		#endfunc

		#When the video icon is clicked
		document
			.getElementById 'toggle-video'
			.addEventListener 'click', (e) => ->
				e.preventDefault()
				elem = document.getElementById 'toggle-video'

				if myStream.getVideoTracks()[0].enabled
					e.target.classList.remove 'fa-video'
					e.target.classList.add 'fa-video-slash'
					elem.setAttribute 'title', 'Show Video'
					myStream.getVideoTracks()[0].enabled = false
				else
					e.target.classList.remove 'fa-video-slash'
					e.target.classList.add 'fa-video'
					elem.setAttribute 'title', 'Hide Video'
					myStream.getVideoTracks()[0].enabled = true
				#endif
				broadcastNewTracks myStream, 'video'
				#endfunc

		document
			.getElementById 'toggle-mute'
			.addEventListener 'click', (e) => ->
				e.preventDefault()
				elem = document.getElementById 'toggle-mute'

				if myStream.getAudioTracks()[0].enabled
					e.target.classList.remove 'fa-microphone-alt'
					e.target.classList.add 'fa-microphone-alt-slash'
					elem.setAttribute 'title', 'Unmute'
					myStream.getAudioTracks()[0].enabled = false
				else
					e.target.classList.remove 'fa-microphone-alt-slash'
					e.target.classList.add 'fa-microphone-alt'
					elem.setAttribute 'title', 'Mute'
					myStream.getAudioTracks()[0].enabled = true
				#endif
				broadcastNewTracks myStream, 'audio'
				#endfunc

		document
			.getElementById 'share-screen'
			.addEventListener 'click', (e) => ->
				e.preventDefault()

				if screen and screen.getVideoTracks().length and screen.getVideoTracks()[0].readyState != 'ended'
					stopSharingScreen()
				else
					shareScreen()
					#endif
				#endfunc

		document
			.getElementById 'record'
			.addEventListener 'click', (e) => ->
				# Ask user what they want to record.
				# Get the stream based on selection and start recording
				if !mediaRecorder or mediaRecorder.state == 'inactive'
					h.toggleModal 'recording-options-modal', true
				else if mediaRecorder.state == 'paused'
					mediaRecorder.resume()
				else if mediaRecorder.state == 'recording'
					mediaRecorder.stop()
					#endif
				#endfunc

		document
			.getElementById 'record-screen'
			.addEventListener 'click', => ->
				h.toggleModal 'recording-options-modal', false

				if screen and screen.getVideoTracks().length
					startRecording screen
				else
					h
						.shareScreen()
						.then (screenStream) => ->
							startRecording screenStream
							#endfunc
						.catch => ->
					#endif
				#endfunc

		document
			.getElementById 'record-video'
			.addEventListener 'click', => ->
				h.toggleModal 'recording-options-modal', false

				if myStream and myStream.getTracks().length
					startRecording myStream
				else
					h
						.getUserFullMedia()
						.then (videoStream) => ->
							startRecording videoStream
							#endfunc
						.catch => ->
				#endif
				#endfunc
		#endif
	#endif
#endfunc
