# Jira Local Config

Org-specific values for the `jira-*` skills. Copy this file to `local.md` (gitignored) and fill it in. Skills refer to each value as `{{NAME}}`.

## Site

| Name                | Value                                                                  |
| ------------------- | ---------------------------------------------------------------------- |
| `JIRA_SITE`         | `https://<your-site>.atlassian.net`                                    |
| `ACTIVE_SPRINT_URL` | `{{JIRA_SITE}}/jira/software/c/projects/<PROJ>/boards/<board-id>`      |
| `BACKLOG_URL`       | `{{JIRA_SITE}}/jira/software/c/projects/<PROJ>/boards/<board-id>/backlog` |
| `TECH_KANBAN_URL`   | `{{JIRA_SITE}}/jira/software/c/projects/<PROJ>/boards/<board-id>`      |

## Projects

| Name              | Value                                                  |
| ----------------- | ------------------------------------------------------ |
| `TEAM_GROUP`      | `<team-group>`                                         |
| `PROJECTS`        | `ABC, XYZ`                                             |
| `DEFAULT_PROJECT` | `ABC` — default for new issues and single-project JQL  |
| `KEY_REGEX`       | `^(ABC\|XYZ)-\d+$`                                     |
| `EXAMPLE_KEY`     | `ABC-12345`                                            |
| `TECH_DEBT_LABEL` | `<tech-debt-label>`                                    |

| Project | Notes                                                                                                 |
| ------- | ----------------------------------------------------------------------------------------------------- |
| `ABC`   | Default project. Custom field IDs below were verified here.                                           |
| `XYZ`   | Use when the user names it or the work belongs there. Ask if unclear which project a new issue is for. |

## Custom Field IDs

Find these with `acli jira workitem view <KEY> --json --fields "*all"` on an existing issue.

| Name              | Value                |
| ----------------- | -------------------- |
| `CF_TEAM`         | `customfield_<id>`   |
| `CF_AC`           | `customfield_<id>`   |
| `CF_TECH_NOTES`   | `customfield_<id>`   |
| `CF_EPIC_LINK`    | `customfield_<id>`   |
| `CF_STORY_POINTS` | `customfield_<id>`   |
| `CF_SPRINT`       | `customfield_<id>`   |

## Team IDs (`CF_TEAM`)

| Team        | ID          |
| ----------- | ----------- |
| <team-name> | `<team-id>` |

## Creation Defaults

| Name                  | Value                                                                                     |
| --------------------- | ----------------------------------------------------------------------------------------- |
| `DEFAULT_TEAM`        | <team-name> — `<team-id>`                                                                 |
| `GROOMING_SPRINT_ID`  | `<sprint-id>` (a number). The fixed sprint used by the grooming / Dev Ready Kanban board. |
| `ASSIGNEE_NAME`       | <your name>                                                                               |
| `ASSIGNEE_ACCOUNT_ID` | `<your-atlassian-account-id>`                                                             |
