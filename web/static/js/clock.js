export class Clock {
  static run(element_list) {
    var today = new Date();
    var hours = today.getHours();
    var minutes = today.getMinutes();
    var seconds = today.getSeconds();
    var first_element = element_list[0]
    first_element.innerHTML = hours + ":" + minutes + ":" + seconds;
    var timeout = setTimeout(function() { Clock.run(element_list) } , 500);
  }
}
