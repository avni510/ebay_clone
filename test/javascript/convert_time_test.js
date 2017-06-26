import assert  from "assert"
import { JSDOM } from "jsdom";
import { Converter } from "../../web/static/js/convert_time";

describe("execute()", function() {

  it("converts utc time to browser specific timezone", function() {
    const dom = new JSDOM('<html><body><div data-datetime> 2018-08-01 10:00:00.000000Z</div></body></html>')
    var document = dom.window.document;
    const elements = document.querySelectorAll("div[data-datetime]");

    Converter.execute(elements);

    var dateElement = document.querySelectorAll("div[data-datetime]")[0];
    assert.equal(dateElement.innerHTML, "08-01-2018 05:00:00");
  });

  it("does not change the value of the html element if it is not an iso formatted date", function() {
    const dom = new JSDOM('<html><body><div data-datetime>hello world</div></body></html>')
    var document = dom.window.document;
    const elements = document.querySelectorAll("div[data-datetime]");

    Converter.execute(elements);

    var dateElement = document.querySelectorAll("div[data-datetime]")[0];
    assert.equal(dateElement.innerHTML, "hello world");
  });
});
