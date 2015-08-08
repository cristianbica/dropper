
require 'thor'

module Droppper
  module Commands
    class Images < Thor
      default_command :list

      desc "list [SEARCH_STRING]", "Retrieve the list of images"
      method_option "type",
                    type: :string,
                    aliases: "-t",
                    default: 'all',
                    enum: %w(all distribution dist application app user),
                    desc: "Specifies which images to retrieve (all, distribution / dist, application / app or user images)"
      def list(*args)
        Droppper::Images.list(*args, options)
      end

      desc "rename NEW_NAME [IMAGE_ID_OR_SEARCH]", "Rename an image"
      def rename(new_name, *args)
        Droppper::Images.rename(new_name, *args)
      end

      desc "destroy [IMAGE_ID_OR_SEARCH]", "Rename an image"
      def destroy(*args)
        Droppper::Images.destroy(*args)
      end

      desc "transfer NEW_REGION [IMAGE_ID_OR_SEARCH]", "Transfers an image to another region"
      def transfer(new_region, *args)
        Droppper::Images.transfer(new_region, *args)
      end

      desc "convert [IMAGE_ID_OR_SEARCH]", "Convert a backup to a snapshot"
      def convert(*args)
        Droppper::Images.convert(*args)
      end

      desc "actions IMAGE_ID", "Show actions in progress for an image"
      def actions(image_id)
        Droppper::Images.actions(image_id)
      end

      desc "show_action IMAGE_ID ACTION_ID", "Show an action status for an image and repeats until done"
      def show_action(image_id, action_id)
        Droppper::Images.show_action(image_id, action_id)
      end

      desc "monitor_action IMAGE_ID ACTION_ID", "Show an action status for an image and repeats until done"
      def monitor_action(image_id, action_id)
        Droppper::Images.monitor_action(image_id, action_id)
      end
    end
  end
end
