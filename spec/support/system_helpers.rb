module SystemHelpers
  # placeで使用
  def tokyo_station_create
    sleep(3)
    find_by_id('create').click
    page.execute_script("document.getElementById('address').value = 'tokyo-station'")
    find_by_id('search-button').click
    sleep(3)
    fill_in '登録名', with: 'tokyo-station'
    fill_in 'memo', with: 'Tokyo'
    select('others', from: 'place_category_id')
    click_button '登録を完了する'
  end

  def tokyo2_station_create
    sleep(3)
    find_by_id('create').click
    page.execute_script("document.getElementById('address').value = 'tokyo-station'")
    find_by_id('search-button').click
    sleep(3)
    fill_in '登録名', with: 'tokyo-station2'
    fill_in 'memo', with: 'Tokyo2'
    select('others', from: 'place_category_id')
    click_button '登録を完了する'
  end

  def sapporo_station_create
    sleep(3)
    find_by_id('create').click
    page.execute_script("document.getElementById('address').value = 'sapporo-station'")
    find_by_id('search-button').click
    sleep(3)
    fill_in '登録名', with: 'sapporo-station'
    fill_in 'memo', with: 'Hokkaido'
    select('others', from: 'place_category_id')
    click_button '登録を完了する'
  end

  def yokohama_station_create
    sleep(3)
    find_by_id('create').click
    page.execute_script("document.getElementById('address').value = 'yokohama-station'")
    find_by_id('search-button').click
    sleep(3)
    fill_in '登録名', with: 'yokohama-station'
    fill_in 'memo', with: 'Kanagawa'
    select('others', from: 'place_category_id')
    click_button '登録を完了する'
  end

  # gone_placeで使用
  def tokyo_station_create_use_in_gone_place
    sleep(3)
    find_by_id('create').click
    page.execute_script("document.getElementById('address').value = 'tokyo-station'")
    find_by_id('search-button').click
    sleep(3)
    fill_in '登録名', with: 'tokyo-station'
    fill_in 'レビュー', with: 'Tokyo'
    fill_in 'myスコア (1~10点)', with: 1
    select('others', from: 'gone_place_category_id')
    click_button '登録を完了する'
  end

  def tokyo2_station_create_use_in_gone_place
    sleep(3)
    find_by_id('create').click
    page.execute_script("document.getElementById('address').value = 'tokyo-station'")
    find_by_id('search-button').click
    sleep(3)
    fill_in '登録名', with: 'tokyo-station2'
    fill_in 'レビュー', with: 'Tokyo2'
    fill_in 'myスコア (1~10点)', with: 2
    select('others', from: 'gone_place_category_id')
    click_button '登録を完了する'
  end

  def sapporo_station_create_use_in_gone_place
    sleep(3)
    find_by_id('create').click
    page.execute_script("document.getElementById('address').value = 'sapporo-station'")
    find_by_id('search-button').click
    sleep(3)
    fill_in '登録名', with: 'sapporo-station'
    fill_in 'レビュー', with: 'Hokkaido'
    fill_in 'myスコア (1~10点)', with: 10
    select('others', from: 'gone_place_category_id')
    click_button '登録を完了する'
  end

  def yokohama_station_create_use_in_gone_place
    sleep(3)
    find_by_id('create').click
    page.execute_script("document.getElementById('address').value = 'yokohama-station'")
    find_by_id('search-button').click
    sleep(3)
    fill_in '登録名', with: 'yokohama-station'
    fill_in 'レビュー', with: 'Kanagawa'
    fill_in 'myスコア (1~10点)', with: 5
    select('others', from: 'gone_place_category_id')
    click_button '登録を完了する'
  end

  # recommend_placeで使用
  def tokyo_station_create_use_in_recommend_place
    tokyo_station_create_use_in_gone_place
    click_link 'tokyo-station'
    click_button 'おすすめに公開する'
    fill_in '登録名', with: 'tokyo-station'
    fill_in 'おすすめコメント', with: 'good'
    click_button '登録を完了する'
  end
end
