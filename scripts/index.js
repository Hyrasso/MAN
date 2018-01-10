let adr = "http://619d8804.ngrok.io/man"
let websocket = new WebSocket('ws://' + adr)

const DEBUG = true
let info = []

let squareSize = 20
let color = 0.5

let rotation = {} // sent with all events
let acceleration = {} 

let pTouch = []

function getId() {
    if (!sessionStorage.getItem("man_id")) {
        return (new Date()).getTime() % 1000000000 + Math.random()
    } else {
        return sessionStorage.getItem("man_id")
    }
}

const MAN_ID = getId();
const ID_OBJ = {id: MAN_ID}
sessionStorage.setItem("man_id", MAN_ID)
console.log(MAN_ID)

function sendEvent(info) {
    let rotation_infos = {}
    if (Object.keys(rotation).length !== 0) {
        rotation_infos = {rotation: rotation}
    }
    let message_object = Object.assign(info, rotation_infos, ID_OBJ)
    let message = JSON.stringify(Object.assign(info, ID_OBJ))
    websocket.send(message)
}

function formatTouch(o) {
    // TODO: id between 1 - 5
    return {x:o.x / width, y:o.y/height, id:o.id}
}

websocket.onclose = function (event) {
    if (event.code == 3001) {
        console.log("Connection closed")
    } else {
        console.log("Connection error")
    }
}

websocket.onmessage = function (event) {
    console.log(event)
    if (event.data == "PING")
        websocket.send("PONG")
}

function setup() {
    createCanvas(windowWidth - 1, windowHeight - 1)
    colorMode(HSB, 1, 1, 1)
    background(0, 0, 1)
    color = random()
}

function windowResized() {
    resizeCanvas(windowWidth, windowHeight)
}

function draw() {
    background(color, .5, .7)
    if (websocket.readyState != websocket.OPEN) {
        push()
        fill(1, 1, 0.5)
        textAlign(CENTER)
        text("Not connected", width / 2, height / 2)
        pop()
        textAlign(LEFT)
    }
    if (DEBUG)
    info.forEach((e, i) => {
        i++
        if (i < windowHeight / 20) {
            text(e, 10, i * 20)
        }
    });
}

function deviceMoved() {
    acceleration = {
        x: accelerationX,
        y: accelerationY,
        z: accelerationZ,
        px: pAccelerationX,
        py: pAccelerationY,
        pz: pAccelerationZ,
    }

    // map to +- 1
    rotation = {
        z: rotationZ / 360,
        x: rotationX / 180,
        y: rotationY / 90,
        pz: pRotationZ / 360,
        px: pRotationX / 180,
        py: pRotationY / 90,
    }
    // info.unshift("Moved")
}

function deviceShaken() {
    info.unshift("Shake")
    sendEvent({
        message: "Shaken",
        type: "shake"
    })
}

function touchMoved() {
    info.unshift("Moves " + touches.length)
    if (typeof touches[0] == "undefined") {
        console.log("No touch")
        let pos = {x:mouseX / width, y:mouseY/height, id:0}
        sendEvent({
            message: "Touch move",
            touch: formatTouch(pos),
            type: "move"
        })
    } else {
        touches.forEach((e) => {
            sendEvent({
                message: "Touch move",
                touch: formatTouch(e),
                type: "move"
            })
        })
    }
    return false
}

function touchStarted() {
    info.unshift("Touch started")
    let precedentTouches = pTouch.map((e) => e.id)
    touches.forEach((e) => {
        if (!(e.id in precedentTouches)) {
            sendEvent({
                message: "Touche start",
                touch: formatTouch(e),
                type: "start"
            })
        }
    })
    pTouch = touches
    return false
}

function touchEnded() {
    info.unshift("Touch ended")
    let currentTouches = touches.map((e) => e.id)
    pTouch.forEach((e) => {
        if (!(e.id in currentTouches)) {
            sendEvent({
                message: "Touche end",
                touch: formatTouch(
                    pTouch.filter((o) => o.id == e.id)[0]),
                type: "end"
            })
        }
    })
    pTouch = touches
    return false
}