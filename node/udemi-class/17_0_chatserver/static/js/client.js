const $doc = document;
const $form = $doc.querySelector('#chat-form');
const $message = $form.querySelector('#message');
const $loc = $form.querySelector('#loc');
const $button = $form.querySelector('button');
const $result = $doc.querySelector('#results');


const socket = io()
const {username, room} = Qs.parse(location.search, {ignoreQueryPrefix: true});

socket.emit('join', {userName: username , roomName: room}, (data) => {
    if(data.error) {
        alert(data.error);
        location.href = "/index.hbs";
    } else {
        renderResult(data);
    }
});

socket.on("message", (message) => {
    renderResult(message);
});

socket.on("users", ({roomName, users}) => {
    document.querySelector(".room-title").innerHTML = roomName
    var ulNode = document.querySelector(".users")
    ulNode.innerHTML = ""

    for(let index in users) {
        var node = $doc.createElement("li");
        node.append(users[index].userName);
        ulNode.append(node);
    }
})

$form.addEventListener("submit", async (e) => {
    e.preventDefault();

    try {
        if(0 == $message.value.length) {
            return;
        }
        let data = {message: $message.value};
        data.time = new Date();

        if(navigator.geolocation && $loc.checked) {
            navigator.geolocation.getCurrentPosition(async (pos) => {
                data.loc = {};
                data.loc.latitude = pos.coords.latitude;
                data.loc.longitude = pos.coords.longitude;

                await send(data);
            });
        } else {
            await send(data);
        }
    } catch(err) {
        console.log(e, err);
    }

});

async function send(data) {
    $button.setAttribute("disabled", "disabled")
    await socket.emit('message-request', data, (errorCallbackMessage) => {
        if(errorCallbackMessage) {
            alert(errorCallbackMessage.message);
        } else {
            $message.value = '';
        }

        $button.removeAttribute("disabled");
        $message.focus();
    });
}

function renderResult(data) {
    console.log("Render", data);
    var node = $doc.createElement("div");
    var user = data.userName ? data.userName + ": " : ""
    node.append(moment(data.createdAt).format("h:mm a") + " " + user + data.message);

    if(data.loc){
        var anchor = $doc.createElement("a");
        let url = `https://www.google.com/maps?longtitude=${data.loc.latitude}&latitude=${data.loc.longitude}`;
        anchor.setAttribute("href", url);
        anchor.append("User location");

        node.append(" [ ");
        node.appendChild(anchor);
        node.append(" ] ");
    }

    $result.append(node);
    autoscroll();
}

function autoscroll() {
    let lastChild = $result.lastElementChild

    let styles = getComputedStyle(lastChild)
    let margin = parseInt(styles.marginBottom)
    let height = lastChild.offsetHeight + margin

    // visible height of the results
    let visibleHeight = $result.offsetHeight
    // actual height of results
    let actualHeight = $result.scrollHeight
    // how far we scrolled
    let scrollOffset = $result.scrollTop + visibleHeight

    console.log(actualHeight - height, scrollOffset)
    if(actualHeight - height <= scrollOffset + 1) {
        $result.scrollTop = $result.scrollHeight
    }
}