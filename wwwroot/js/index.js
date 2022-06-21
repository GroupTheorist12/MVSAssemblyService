/*
tablinks = document.getElementsByClassName("tablinks");

for (i = 0; i < tablinks.length; i++) {
    tablinks[i].addEventListener('click', function (event) {
        event.preventDefault();
        openContent(event);
    });
}

thecontents = document.getElementsByClassName("thecontent");
for (i = 0; i < thecontents.length; i++) {
    thecontents[i].style.display = "none";
}

function openContent(evt) {
    thecontents = document.getElementsByClassName("thecontent");
    for (i = 0; i < thecontents.length; i++) {
        thecontents[i].style.display = "none";
    }
    //content.style.display = "block";

    let id = evt.target.getAttribute('href').replace("#", "");

    document.getElementById(id).style.display = "block";
    document.getElementById("h2Chapter").innerText = evt.target.innerText;
    let pre_id = "pre_" + id;
    fetch('/GetPrintText/?index=0')
        .then(response => response.text())
        .then(data => document.getElementById(pre_id).innerText = data);
}

var toggler = document.getElementsByClassName("caret");
var i;

for (i = 0; i < toggler.length; i++) {
    toggler[i].addEventListener("click", function () {
        this.parentElement.querySelector(".nested").classList.toggle("active");
        this.classList.toggle("caret-down");
    });
}
*/

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
 }

class Index {
    constructor() {
        var btn = document.getElementById('btnSubmitJcl');
        let me = this;
        btn.addEventListener('click', function (event) {
            me.handleSubmit(event);
            me.getPrintText();
    
        });
    }

    async getPrintText() {
        await sleep(3000);
        fetch('/GetPrintText/?index=0')
        .then(response => response.text())
        .then(data => document.getElementById("pre_printtext").innerText = data);
        document.getElementById("spnJobMessage").innerText = "";

    }


    async handleSubmit(e) {
        e.preventDefault();
        document.getElementById("pre_printtext").innerText = "";
        document.getElementById("spnJobMessage").innerText = "";
        document.getElementById("spnJobMessage").innerText = "Job Submiited please wait";
        let state = {
            JclFile: document.getElementById('JclFile').value,
            Chapter: document.getElementById('Chapter').value
        };
    
        console.log(state);

        let response = await fetch('/SubmitJcl', { // Change to port you are running on
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(state)
        });


        let data = await response.text();
        /*
        const tmpStuff = data;
        const txtJCL = document.getElementById("txtJCL");
        txtJCL.value = tmpStuff;
        console.log(tmpStuff);
        */
    }
}

let index = new Index();

function SetFiles(arr, chapter)
{
    let sideBar = document.getElementById("divSideNav");
    sideBar.innerHTML = "";
    const a = document.createElement("a");
    a.setAttribute("href", chapter + ".pdf");
    a.setAttribute("target", "_blank");
    a.textContent = chapter + " PDF";
    sideBar.appendChild(a);

    const hr = document.createElement("hr");
    sideBar.appendChild(hr);
    for(var i = 0; i <arr.length; i++)
    {
        const a = document.createElement("a");
        a.setAttribute("href", "#");
        const fil = arr[i];
        a.addEventListener('click', function (event) {
          event.preventDefault();
          document.getElementById("spnJCLFile").innerText = "Current File: " + fil;
          document.getElementById('JclFile').value = fil;
          document.getElementById('Chapter').value = chapter;
          

          url = "/GetJCLText/?Chapter=" + chapter + "&JCLName=" + fil;
          console.log(url);
          fetch(url)
          .then(response => response.text())
          .then(data => document.getElementById("ta_jcl").innerText = data);

        });

        a.textContent = arr[i];
        sideBar.appendChild(a);

    }

    console.log(arr[0]);
}

fetch('/GetPrintText/?index=0')
.then(response => response.text())
.then(data => document.getElementById("pre_printtext").innerText = data);

var children = [].slice.call(document.getElementById('topnav').getElementsByTagName('a'),0);

var arrayLength = children.length;
for (var i = 0; i < arrayLength; i++) {
    children[i].addEventListener('click', function (event) {
        event.preventDefault();
        document.getElementById("divSideNav").innerHTML = "";
        for (var i = 0; i < arrayLength; i++) {
            children[i].classList.remove("active");
        }
        event.target.classList.add("active");

        fetch('/GetJCLFiles/?Chapter='+ event.target.getAttribute('id'))
        .then(response => response.json())
        .then(data => SetFiles(data, event.target.getAttribute('id')));
    });
}