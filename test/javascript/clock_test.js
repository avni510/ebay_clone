import assert  from "assert"
import { JSDOM } from "jsdom";
import { Clock } from "../../web/static/js/clock";

describe("run()", function() {

  it("displays a clock", function() {
    const dom = new JSDOM('<html><body><div id="clock"></div></body></html>');
    var document = dom.window.document;
    const element = document.getElementById("clock");

    var clock = Clock.run(element);

    var clockElement = document.getElementById("clock");
    var today = new Date();
    var hours = today.getHours();
    var minutes = today.getMinutes();
    var seconds = today.getSeconds();
    assert.equal(clockElement.innerHTML, hours + ":" + minutes + ":" + seconds);
    clearTimeout(clock);
  });
})
