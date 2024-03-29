// Run this example by adding <%= javascript_pack_tag "hello_elm" %> to the
// head of your layout file, like app/views/layouts/application.html.erb.
// It will render "Hello Elm!" within the page.

import { Elm } from '../Main'

document.addEventListener('DOMContentLoaded', () => {
  const node = document.createElement('div')

  document.body.appendChild(node)
  Elm.Main.init({ node })
})
