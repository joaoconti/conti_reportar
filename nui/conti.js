$(() => {

    $("body").hide()

    window.addEventListener("message", function (event) {
        let status = event.data.action
        console.log(event)
        switch (status) {
            case "show":
                $("body").show()
                break;
            case "hide":
                $("body").hide()
                break;
        }
    })

    $(".learn-more").click(() => {
        $.post("http://conti_reportar/botao", JSON.stringify({id: $(".id").val(), desc: $(".desc").val()}))
        $(".id").val('')
        $(".desc").val('')
    })
})