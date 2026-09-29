# 注文確認画面: 「お届け先住所と同じ」チェックボックスがチェックされた場合に
# 請求先住所欄にお届け先住所が自動入力される
copyShippingToBilling = ->
  $('.js-shipping-field').each ->
    field = $(this).data('field')
    value = $(this).val()
    $(".js-billing-field[data-field='#{field}']").val(value)

$(document).on 'change', '.js-same-as-shipping', ->
  if $(this).is(':checked')
    copyShippingToBilling()
    $('.js-billing-field').prop('readonly', true)
  else
    $('.js-billing-field').prop('readonly', false)

# チェック済みの状態でお届け先住所欄が変更された場合に、請求先住所も追従して変更される
$(document).on 'input', '.js-shipping-field', ->
  if $('.js-same-as-shipping').is(':checked')
    copyShippingToBilling()

$(document).on 'turbolinks:load', ->
  if $('.js-same-as-shipping').is(':checked')
    copyShippingToBilling()
    $('.js-billing-field').prop('readonly', true)
