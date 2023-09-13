module SystemHelpers
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

  def nagoya_station_create
    sleep(3)
    find_by_id('create').click
    page.execute_script("document.getElementById('address').value = 'nagoya-station'")
    find_by_id('search-button').click
    sleep(3)
    fill_in '登録名', with: 'nagoya-station'
    fill_in 'memo', with: 'Sizuoka'
    select('others', from: 'place_category_id')
    click_button '登録を完了する'
  end
end
