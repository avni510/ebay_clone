export class Clock {
  static run(element) {
    var today = new Date();
    var hours = today.getHours();
    var minutes = today.getMinutes();
    var seconds = today.getSeconds();
    element.innerHTML = hours + ":" + minutes + ":" + seconds;
    var timeout = setTimeout(function() { Clock.run(element) } , 500);
    return timeout;
  }
}
