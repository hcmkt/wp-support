# wp-support
Update tool for WordPress sites

## Requirements
- [Task](https://github.com/go-task/task)
- [jq](https://github.com/stedolan/jq)
- [yq](https://github.com/mikefarah/yq)

## Usage
1. If the connection information is not included in the `env.json` file, run the following command and then write the necessary information in the `.env.json` file.
    ```sh
    task add
    ```

    The necessary information are as follows.
    ```yaml
    - name:             # unique name
      stg:
        host:           # Host written in ~/.ssh/config
        pass: xxxxx     # password for Host (if not password authentication, set any string)
        wp_dir:         # WordPress document root
        wp_cmd:         # wp command
        wp_log:         # log file path
      prod:
        host:           # Host written in ~/.ssh/config
        pass: xxxxx     # password for Host (if not password authentication, set any string)
        wp_dir:         # WordPress document root
        wp_cmd:         # wp command
        wp_log:         # log file path
    ```

1. To set the required information in `.env`, execute the following command.
    ```sh
    task init -- <name> <environment>
    ```

1.  Next, execute the following command. This command will back up and version your plugins and themes, as well as activate WP's debug mode.
    ```sh
    task prepare
    ```

1. If you have plugins or themes that you do not want to update, set `update` to `none` in `plugin.json` or `theme.json`.

1. To view the update information, execute the following command.
    ```sh
    task show
    ```

1. The following command will actually perform the upgrade.
    ```sh
    task update
    ```

1. After the upgrade is complete, execute the following command. This command reverts `wp-config.php` back to its original state and gets a backup of the log.
    ```sh
    task clean
    ```

1. To delete the log in server, execute the following command.
   ```sh
   task rmlog
   ```
