require 'rails_helper'

RSpec.describe 'Lesson Completions', type: :system do
  let!(:user) { create(:user) }
  let!(:path) { create(:path, default_path: true) }
  let!(:course) { create(:course, path: path) }
  let!(:section) { create(:section, course: course) }
  let!(:lesson) { create(:lesson, section: section) }

  context 'when user is signed in' do
    before do
      sign_in(user)
      visit path_course_lesson_path(path, course, lesson)
    end

    it 'can complete a lesson' do
      find(:test_id, 'complete-button').click

      expect(page).to have_button('Lesson Completed')
      expect(page).not_to have_button('Mark Complete')
      expect(user.lesson_completions.pluck(:lesson_id)).to include(lesson.id)
    end

    it 'can change a completed lesson to incomplete' do
      find(:test_id, 'complete-button').click

      expect(page).to have_button('Lesson Completed')
      expect(user.lesson_completions.pluck(:lesson_id)).to include(lesson.id)

      find(:test_id, 'complete-button').click

      expect(page).to have_button('Mark Complete')
      expect(page).not_to have_button('Lesson Completed')
      expect(user.lesson_completions.pluck(:lesson_id)).not_to include(lesson.id)
    end
  end

  context 'when user is not signed in' do
    it 'cannot complete a lesson' do
      visit path_course_lesson_path(path, course, lesson)

      expect(page).not_to have_button('Mark Complete')
      expect(page).not_to have_button('Lesson Completed')
      expect(find(:test_id, 'login_button')).to have_content('Login to track progress')
    end
  end
end
