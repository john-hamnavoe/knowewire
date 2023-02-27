import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect(){
      this.element.focus()
      let elementValue = this.element.value
      this.element.value = ''
      this.element.value = elementValue
      console.log(this.element, elementValue)
    }
}