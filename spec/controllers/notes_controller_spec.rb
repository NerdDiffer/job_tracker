require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  let(:user) { build(:user, id: 1) }
  let(:note) { build(:note, id: 1) }
  let(:contact) { build(:contact) }
  let(:job_application) { build(:job_application, id: 1) }

  before(:each) { log_in_as(user) }

  xdescribe 'GET #index' do
    before(:each) do
      allow(Note).to receive(:sorted).and_return(note)
      allow(@controller).to receive(:custom_index_sort).and_return([note])
      get(:index, sort: true)
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns all notes as @notes' do
      expect(assigns(:notes)).to eq([note])
    end
    it 'renders index' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    shared_examples_for '#show via host resource' do
      it 'returns a 200' do
        expect(response).to have_http_status(200)
      end
      it 'assigns the requested note as @note' do
        expect(assigns(:note)).to eq(note)
      end
      it 'renders show' do
        expect(response).to render_template(:show)
      end
    end

    context 'Nested inside of contacts/' do
      it_behaves_like '#show via host resource' do
        before(:each) do
          allow(Note).to receive(:find).and_return(note)
          allow(Contact).to receive(:find).and_return(contact)
          get(:show, contact_id: 'joe-schmoe', id: 1)
        end
      end
    end

    context 'Nested inside of job_applications/' do
      it_behaves_like '#show via host resource' do
        before(:each) do
          allow(Note).to receive(:find).and_return(note)
          allow(JobApplication).to receive(:find).and_return(job_application)
          get(:show, job_application_id: 1, id: 1)
        end
      end
    end
  end

  describe 'GET #new' do
    shared_examples_for '#new via host resource' do
      it 'returns a 200' do
        expect(response.code).to eq '200'
      end
      it '@notable is an instance of the host resource' do
        expect(assigns(:notable)).to eq host
      end
      it 'assigns a new note as @note' do
        expect(assigns(:note)).to be_a_new(Note)
      end
    end

    context 'Nested inside of contacts/' do
      it_behaves_like '#new via host resource' do
        let(:host) { contact }

        before(:each) do
          allow(Note).to receive(:find).and_return(note)
          allow(Contact).to receive(:find).and_return(contact)
          get(:new, contact_id: 1)
        end
      end
    end
    context 'Nested inside of job_applications/' do
      it_behaves_like '#new via host resource' do
        let(:host) { job_application }

        before(:each) do
          allow(Note).to receive(:find).and_return(note)
          allow(JobApplication).to receive(:find).and_return(job_application)
          get(:new, job_application_id: 1)
        end
      end
    end
  end

  describe 'GET #edit' do
    shared_examples_for '#edit via host resource' do
      it 'returns a 200' do
        expect(response).to have_http_status(200)
      end
      it 'assigns the requested company as @note' do
        expect(assigns(:note)).to eq(note)
      end
      it 'renders edit' do
        expect(response).to render_template(:edit)
      end
    end

    context 'Nested inside of contacts/' do
      it_behaves_like '#edit via host resource' do
        before(:each) do
          allow(Note).to receive(:find).and_return(note)
          allow(Contact).to receive(:find).and_return(contact)
          get(:edit, contact_id: 'joe-schmoe', id: 1)
        end
      end
    end

    context 'Nested inside of job_applications/' do
      it_behaves_like '#edit via host resource' do
        before(:each) do
          allow(Note).to receive(:find).and_return(note)
          allow(JobApplication).to receive(:find).and_return(job_application)
          get(:edit, job_application_id: 1, id: 1)
        end
      end
    end
  end

  describe 'POST #create' do
    shared_examples_for '#create via host resource' do
      before(:each) do
        allow(@controller).to receive(:build_note).and_return(note)
      end

      context 'with valid params' do
        before(:each) do
          allow(note).to receive(:save).and_return(true)
          post(:create, post_attr)
        end

        it 'sets @note to a new Note object' do
          expect(assigns(:note)).to be_a_new(Note)
        end
        it 'redirects to @notable' do
          expect(response).to redirect_to(notable)
        end
      end

      context 'with invalid params' do
        before(:each) do
          allow(note).to receive(:save).and_return(false)
          post(:create, post_attr)
        end

        it 'assigns a newly created but unsaved note as @note' do
          expect(assigns(:note)).to be_a_new(Note)
        end
        it 're-renders the "new" template' do
          expect(response).to render_template('new')
        end
      end
    end

    context 'Nested inside of contacts/' do
      it_behaves_like '#create via host resource' do
        let(:notable) { contact }
        let(:post_attr) do
          {
            note: { contents: '' },
            contact_id: 1
          }
        end

        before(:each) do
          allow(Contact).to receive(:find).and_return(contact)
        end
      end
    end

    context 'Nested inside of job_application/' do
      it_behaves_like '#create via host resource' do
        let(:notable) { job_application }
        let(:post_attr) do
          {
            note: { contents: '' },
            job_application_id: 1
          }
        end

        before(:each) do
          allow(JobApplication).to receive(:find).and_return(job_application)
        end
      end
    end
  end

  describe 'PUT #update' do
    shared_examples_for '#update via host resource' do
      before(:each) do
        allow(Note).to receive(:find).and_return(note)
      end

      context 'with valid params' do
        before(:each) do
          allow(note).to receive(:update).and_return(true)
        end

        it 'assigns the requested note as @note' do
          put(:update, update_attr)
          expect(assigns(:note)).to eq(note)
        end

        it 'calls update on the requested note' do
          expect(note).to receive(:update)
          put(:update, update_attr)
        end

        it 'redirects to notable' do
          put(:update, update_attr)
          expect(response).to redirect_to(notable)
        end
      end

      context 'with invalid params' do
        before(:each) do
          allow(note).to receive(:update).and_return(false)
          put(:update, update_attr)
        end

        it 'assigns the note as @note' do
          expect(assigns(:note)).to eq(note)
        end

        it 're-renders the "edit" template' do
          expect(response).to render_template('edit')
        end
      end
    end

    context 'Nested inside of contacts/' do
      it_behaves_like '#update via host resource' do
        let(:notable) { contact }
        let(:update_attr) do
          {
            note: { contents: '' },
            contact_id: 1,
            id: 1
          }
        end

        before(:each) do
          allow(Contact).to receive(:find).and_return(contact)
        end
      end
    end

    context 'Nested inside of job_application/' do
      it_behaves_like '#update via host resource' do
        let(:notable) { job_application }
        let(:update_attr) do
          {
            note: { contents: '' },
            job_application_id: 1,
            id: 1
          }
        end

        before(:each) do
          allow(JobApplication).to receive(:find).and_return(job_application)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    shared_examples_for '#destroy via host resource' do
      it 'calls destroy on the requested note' do
        expect(note).to receive(:destroy)
        delete(:destroy, delete_opts)
      end

      it 'redirects to the notes list' do
        delete(:destroy, delete_opts)
        expect(response).to redirect_to(notable)
      end
    end

    context 'Nested inside of contacts/' do
      it_behaves_like '#destroy via host resource' do
        let(:delete_opts) { { id: 1, contact_id: 'joe-schmoe' } }
        let(:notable) { contact }

        before(:each) do
          allow(Note).to receive(:find).and_return(note)
          allow(Contact).to receive(:find).and_return(contact)
        end
      end
    end

    context 'Nested inside of job_applications/' do
      it_behaves_like '#destroy via host resource' do
        let(:notable) { job_application }
        let(:delete_opts) { { id: 1, job_application_id: 1 } }

        before(:each) do
          allow(Note).to receive(:find).and_return(note)
          allow(JobApplication).to receive(:find).and_return(job_application)
        end
      end
    end
  end
end
