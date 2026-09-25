# data-confirm を持つリンク・ボタン（削除確認など）を
# ブラウザ標準の confirm() の代わりに Bootstrap モーダルで表示する。
pendingElement = null
confirmed = false

Rails.confirm = (message, element) ->
  $('#confirmModal .modal-body').text(message)
  pendingElement = element
  confirmed = false
  $('#confirmModal').modal('show')
  false

$(document).on 'click', '#confirmModal [data-confirm-accept]', ->
  confirmed = true
  $('#confirmModal').modal('hide')

$(document).on 'hidden.bs.modal', '#confirmModal', ->
  element = pendingElement
  pendingElement = null
  if confirmed and element
    confirmed = false
    element.removeAttribute('data-confirm')
    element.click()
