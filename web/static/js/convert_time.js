import moment from "moment"

export class Converter {
  static execute(tag) {
    let elements = document.querySelectorAll(tag);
    for (var index = 0; index < elements.length; index ++) {
      var element = elements[index];
      let dateString = element.innerHTML.trim();
      if (this.validateDate(dateString)) {
        element.innerHTML = this.getFormattedLocalDate(dateString);
      }
    }
  }

   static validateDate(date) {
     return moment(date, moment.ISO_8601, true).isValid();
   }

   static getFormattedLocalDate(date) {
     var utcDate = moment.utc(date);
     var localDate = moment(utcDate).local();
     return localDate.format("MM-DD-YYYY HH:mm:ss");
   }
}
