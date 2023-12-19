defmodule Stcl1.Messages do

  def message(:first),
    do: "Привет! Я — бот Стендап Клуба на Трубной. Ниже ты найдешь ответы на вопросы, которые интересуют чаще всего. Если здесь нет того, что ты ищешь, напиши свой вопрос в чат и наша команда обязательно тебе ответит с 11:00 до 21:00 по Москве!"
  def message(:menu),
    do: "Выбери вопрос из списка или задай свой вопрос в чат"

  def message(:q_address),
    do: "Рождественский бульвар 10/7 стр.1. (Метро Трубная)."

  def message(:q_shows_list),
    do: "Наше расписание можно посмотреть на [сайте](https://standupclub.ru) или в [социальных сетях](https://t.me/Standupclubru)."

  def message(:q_buy_ticket_on_event),
    do: "Нет, билеты можно приобрести только онлайн на нашем [сайте](https://standupclub.ru) или у других кассовых операторов."

  def message(:q_unrecieved_ticket),
    do: "Проверьте спам или рассылки. Если билета и там не оказалось, напишите еще раз сюда с указанием имени, названием и датой шоу — мы поможем его найти."

  def message(:q_return_ticket),
    do: "Условия возврата уточняются у билетного оператора, через которого вы приобрели билет. Если вы столкнулись с проблемой при возврате, напишите нам с указанием вашего имени, названием и датой шоу, а также причиной возврата."

  def message(:q_show_date),
    do: "Конечно же, на [Big StandUp](https://standupclub.ru/project/big-stand-up). Это шоу где только опытные комики и шутки, проверенные не одной сотней избирательных зрителей. Оно еще и идет со вторника по воскресенье! Мы также советуем [Женский стендап](https://standupclub.ru/project/zhenshchiny-komiki). А если ваш партнер любит стендап определенного комика, то [на нашем сайте](https://standupclub.ru) можно посмотреть актуальные даты Сольных концертов."

  def message(:q_who_big),
    do: "Состав на бигах меняется каждую неделю. Актуальный состав можно найти в наших [соцсетях](https://t.me/Standupclubru) накануне мероприятия или дождаться ответа команды Стендап Клуба здесь. Состав участников какого именно шоу вас интересует?"

  def message(:q_lineup),
    do: "Состав участников какого именно шоу вас интересует?"

  def message(:q_where_schedule),
    do: "Все актуальные составы и расписание на неделю можно смотреть в нашем телеграм-канале!\n\nhttps://t.me/Standupclubru"

  def message(:q_show_duration),
    do: "В среднем каждое шоу длится 1 час 20 минут."

  def message(:q_tables_hundred),
    do: "Это барные столы с высокими барными стульями, которые находятся вдоль стены."

  def message(:q_order_food_drink),
    do: "Конечно — так шоу пройдет еще веселее. Посмотреть [меню](https://standupclub.ru/menu) можно здесь или в приложении bartello."

  def message(:q_show_passport),
    do: "Наши шоу — 18+, поэтому на входе вас попросят показать документы: паспорт или водительские права."

  def message(:q_child_with_batya),
    do: "Можно, но ребенок должен быть вписан в паспорт родителя. Если ребенок не вписан в паспорт, то необходимо показать свидетельство о рождении или другие документы, которые подтверждают, что вы — официальный опекун."

  def message(:q_parking),
    do: "Да! Общегородская."

  def message(:operator_back),
    do: "Спасибо за вопрос! Сейчас позову живого человека — он ответит!"

  def message(:operator_back_later),
    do: "Спасибо за вопрос! У живого человека сейчас нерабочие часы. Он ответит, как только они закончатся!"

  def message(:finish),
    do: "Спасибо за обращение! Я здесь, если еще понадоблюсь. И заглядывай к нам в Стендап Клуб — мы тут каждый день.\n\nИ, конечно, подписывайся на наши соцсети, а еще у нас есть email-рассылка — тоже подписывайся!"

  ## Анкета

  def message(:q_show_advice1),
    do: "Тебе нравится ходить на стендап-концерты или на другие шоу?"

  def message(:q_show_advice_standup),
    do: "Советуем посетить наши флагманские шоу:\n\n[Big Stand Up](https://standupclub.ru/project/big-stand-up?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=bigstandup)\n[Женщины комики](https://standupclub.ru/project/zhenshchiny-komiki?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=zhenshchinykomiki)\n[Жесткий стендап](https://standupclub.ru/project/zhyostkiy-stendap?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=zhyostkiystendap)\n[Лайнап](https://standupclub.ru/project/stendap-laynap?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=laynap)\n[Стендап-комики](https://standupclub.ru/project/stendap-komiki-2?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=stendap-komiki)\n[Вечера комедии](https://standupclub.ru/project/vechera-stendapa?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=vecherakomedii)\n[Благотворительный стендап](https://standupclub.ru/project/blagotvoritelnyy-vecher?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=blagotvoritelniy)"

  def message(:q_show_advice_experiment),
    do: "Тебя могут заинтересовать эти шоу:\n\n[Альтернативная комедия](https://standupclub.ru/project/alternativnaya-komediya?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=alternativnayakomediya)\n[Шоу историй](https://standupclub.ru/project/shou-istoriy-2?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=shou-istoriy)\n[Глаз народа](https://standupclub.ru/project/glaz-naroda?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=glaz-narodahttps://standupclub.ru/project/glaz-naroda?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=glaz-naroda)\n[Стендап на ходу](https://standupclub.ru/project/stendap-na-hodu?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=stendap-na-hodu)\n[Secret show](https://standupclub.ru/project/secret-show?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=secretshow)\n[Стендап за 60 секунд](https://standupclub.ru/project/stendap-s-kommentariyami)\n[Мастерская скетчей](https://standupclub.ru/project/masterskaya-sketchey?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=masterskaya-sketchey)"

  def message(:q_show_advice_panel),
    do: "Советуем посетить эти мероприятия:\n\n[Я не тупой](https://standupclub.ru/project/ya-ne-tupoy?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=ya-ne-tupoy)\n[Ламповый подкаст о философии](https://standupclub.ru/project/lampovyy-podkast-o-filosofii)\n[Пятница 13ко](https://standupclub.ru/project/pyatnica-13ko?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=pyatnica13ko)\n[Глаз народа](https://standupclub.ru/project/glaz-naroda?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=glaz-naroda)\n[Разгоны офлайн](https://standupclub.ru/project/razgony-oflayn?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=razgonyoflayn)\n[Комедийный квиз](https://standupclub.ru/project/komediynyy-kviz?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=komediynyykviz)\n[Что у вас случилось?](https://standupclub.ru/project/chto-u-vas-sluchilos?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=chuvs)"

  def message(:q_show_new_jokes),
    do: "Советуем посетить эти шоу:\n\n[Стендап-комики](https://standupclub.ru/project/stendap-komiki-2?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=stendap-komiki)\n[Проверка материала](https://standupclub.ru/project/proverka-materiala?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=proverka-materiala)\n[Шоу историй](https://standupclub.ru/project/shou-istoriy-2?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=shou-istoriy)\n[Стендап на ходу](https://standupclub.ru/project/stendap-na-hodu?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=stendap-na-hodu)\n[Secret show](https://standupclub.ru/project/secret-show?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=secretshow)"

  def message(:q_show_advice2),
    do: "Тебе нравится принимать непосредственное участие в комедийном шоу?"

  def message(:q_show_advice_yes),
    do: "Мы думаем, тебя заинтересуют эти шоу:\n\n[Комедийный квиз](https://standupclub.ru/project/komediynyy-kviz?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=komediynyykviz)\n[Что у вас случилось?](https://standupclub.ru/project/chto-u-vas-sluchilos?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=chuvs)\n[Стендап на ходу](https://standupclub.ru/project/stendap-na-hodu?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=stendap-na-hodu)\n[Глаз народа](https://standupclub.ru/project/glaz-naroda?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=glaz-naroda)\n[Мастерская скетчей](https://standupclub.ru/project/masterskaya-sketchey?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=masterskaya-sketchey)"

  def message(:q_show_advice_no),
    do: "Мы думаем, ты заинтересуешься этими шоу:\n\n[Big Stand Up](https://standupclub.ru/project/big-stand-up?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=bigstandup)\n[Жесткий стендап](https://standupclub.ru/project/zhyostkiy-stendap?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=zhyostkiystendap)\n[Женщины комики](https://standupclub.ru/project/zhenshchiny-komiki?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=zhenshchinykomiki)\n[Стендап-комики](https://standupclub.ru/project/stendap-komiki-2?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=stendap-komiki)\n[Я не тупой](https://standupclub.ru/project/ya-ne-tupoy?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=ya-ne-tupoy)\n[Шоу историй](https://standupclub.ru/project/shou-istoriy-2?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=shou-istoriy)\n[Разгоны офлайн](https://standupclub.ru/project/razgony-oflayn?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=razgonyoflayn)\n[Вечера комедии](https://standupclub.ru/project/vechera-stendapa?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=vecherakomedii)\n[Проверка материала](https://standupclub.ru/project/proverka-materiala?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=proverkamateriala)\n[Альтернативная комедия](https://standupclub.ru/project/alternativnaya-komediya?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=alternativnayakomediya)\n[Ламповый подкаст о философии](https://standupclub.ru/project/lampovyy-podkast-o-filosofii)\n[Стендап за 60 секунд](https://standupclub.ru/project/stendap-s-kommentariyami)\n[Благотворительный стендап](https://standupclub.ru/project/blagotvoritelnyy-vecher?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=blagotvoritelniy)\n[Пятница 13ко](https://standupclub.ru/project/pyatnica-13ko?utm_source=club_telegram_bot&utm_medium=social&utm_campaign=club_telegram_bot&utm_term=pyatnica13ko)"
end
