import assert  from "assert"
import { JSDOM } from "jsdom";
import { Clock } from "../../web/static/js/clock";

describe("run()", function() {

  it("displays a clock", function() {
    const dom = new JSDOM('<html><body><div data-clock></div></body></html>');
    var document = dom.window.document;
    const elements = document.querySelectorAll("div[data-clock]");

    Clock.run(elements);

    var clockElement = document.querySelectorAll("div[data-clock]")[0];
    var today = new Date();
    var hours = today.getHours();
    var minutes = today.getMinutes();
    var seconds = today.getSeconds();
    assert.equal(clockElement.innerHTML, hours + ":" + minutes + ":" + seconds);
  });
})
