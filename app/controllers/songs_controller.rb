class SongsController < ApplicationController

  def index
  end

  def new
  end

  def create

    @bucket = bucket
    @resource = upload_resource




    # Upload the song
    obj = @resource.bucket('bytewayve').object(params[:file].original_filename)
    obj.upload_file(params[:file].path, acl: "public-read")

    puts



    # Create an object for the upload
    @song = Song.new(
      url: obj.public_url,
      filename: obj.key,
      owner_id: current_user.id
    )

    # Save the upload
    if @song.save
      redirect_to songs_path, success: 'File successfully uploaded'
    else
      flash.now[:notice] = 'There was an error'
      render :new
    end
  end

  def show
    @song = Song.find(params[:id])
  end

  def destroy

    @song = Song.find(params[:id])

    if (@song)
      @song.destroy_both
      redirect_to songs_path
    else
      render :text => "No song was found to delete!"
    end

  end


  private

  def upload_resource
    Aws::S3::Resource.new(region:'us-west-2')
  end

  def buckets
    s3 = Aws::S3::Client.new
    resp = s3.list_buckets
    resp.buckets
  end

  def bucket
    buckets.first
  end
end
