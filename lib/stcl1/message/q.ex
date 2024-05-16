defmodule Stcl1.Message.Q do
  defmacro __using__(_opts) do
    quote do
      @q_lineup "Актуальные составы на шоу"
      @q_lineup_big "BigStandUp"
      @q_lineup_tough "Жесткий стендап"
      @q_lineup_women "Женщины комики"

      @q_shows_list "Какие шоу идут в Стендап Клубе сегодня?"

      @q_show_advice "Посоветуйте, на какое шоу сходить"
      @q_show_advice_standup "Стендап"
      @q_show_advice_experiment "Комедийные эксперименты"
      @q_show_advice_panel "Пэнел шоу"
      @q_show_new_jokes "Новые шутки"
      @q_show_advice_something_else "Хочу посмотреть что-то еще"
      @q_show_advice_yes "Да"
      @q_show_advice_no "Нет"

      @q_show_date "На какое шоу пойти с девушкой/парнем?"

      @q_tickets "Покупка и возврат билетов"
      @q_buy_ticket_on_event "Хочу купить билеты на месте. Это возможно?"
      @q_unrecieved_ticket "Приобрел билет, но мне он не пришел. Что делать?"
      @q_return_ticket "Хочу вернуть билет. Как это сделать?"

      @q_loyalty_card "Карта лояльности"
      @q_gift_cert "Подарочный сертификат"
      @q_our_soc_networks "Наши социальные сети"

      @q_show_duration "Сколько длится шоу?"
      @q_order_food_drink "Хочу заказать еду и напитки. Могу ли я это сделать?"
      @q_show_passport "Обязательно ли показывать паспорт?"
      @q_child_with_batya "Можно ли несовершеннолетнему с родителями?"
      @q_address "Какой адрес у Стендап Клуба?"
      @q_parking "Есть ли у вас парковка?"

      @q_back "В главное меню"
    end
  end
end
