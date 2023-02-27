import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect(){
      this.element.oninput = this.oninput
    }

    oninput(event) {
      if (!event.target.value.endsWith(' ')) {
        event.target.form.requestSubmit();
      }
    }
}