defmodule Stcl1.Pictures do
  @groups %{
    group1: [
      "AgACAgIAAxkBAAIVFWRaauo4reNadx_gHXkvDeWWu7z5AAKPyTEbwCzQStkmfqvUEoDCAQADAgADcwADLwQ",
      "AgACAgIAAxkBAAIVFmRaaurLPyELjJJExNdc0QxUAAG2bAACkMkxG8As0EqPTu7M9b2dggEAAwIAA3MAAy8E",
      "AgACAgIAAxkBAAIVF2Raauo2o8eGWkXjliU4nM-BvwgMAAKRyTEbwCzQStN_FFK35ALOAQADAgADcwADLwQ",
      "AgACAgIAAxkBAAIVGGRaaupCZBIPwQUvK3E0zzIIoo5HAAKSyTEbwCzQSvskFtQFAAGq8wEAAwIAA3MAAy8E"
    ],

    group2: [
      "AgACAgIAAxkBAAIVHWRaa_q0iYwcmA-crf7ZekVodIsGAAKXyTEbwCzQSj9hsyuFCx-xAQADAgADcwADLwQ",
      "AgACAgIAAxkBAAIVHGRaa_rBF2MKRHcFGGEddIRYa01oAAKayTEbwCzQSme4WtzwMYjAAQADAgADcwADLwQ",
      "AgACAgIAAxkBAAIVG2Raa_r9Y9nQSwfTcBD2RMwF80NLAAKYyTEbwCzQSuAilQ4Gy7NRAQADAgADcwADLwQ",
      "AgACAgIAAxkBAAIVGmRaa_rRxfjsWM9TyV8cLI_yrwABCgACmckxG8As0ErFrWu0M2dRggEAAwIAA3MAAy8E"
    ],

    group3: [
      "AgACAgIAAxkBAAIVHmRabEqoYhAk49C10dqtgEkAAXY_4AACnMkxG8As0Eqi8FSeCiRI0gEAAwIAA3MAAy8E",
      "AgACAgIAAxkBAAIVH2RabEpG8I7uvwABx0hYM0ms11qF8wACnckxG8As0Eodt1fVR5-pVgEAAwIAA3MAAy8E",
      "AgACAgIAAxkBAAIVIGRabErN47QIMNBr8g2wti7pD8hXAAKeyTEbwCzQSmA3YO-r6NA6AQADAgADcwADLwQ",
      "AgACAgIAAxkBAAIVIWRabEqSNYdk7auXIFJRROy2UQxAAAKfyTEbwCzQStOFNHNAR5JLAQADAgADcwADLwQ"
    ],

    group4: [
      "AgACAgIAAxkBAAIVJWRabMgbWBXDacNO-mSI77XVTNVyAAKqyTEbwCzQSnt-C_E0bS3-AQADAgADcwADLwQ",
      "AgACAgIAAxkBAAIVJGRabMgbb5SgDMATr9vgUdpKdqFYAAKnyTEbwCzQSrWL_k02ktLeAQADAgADcwADLwQ",
      "AgACAgIAAxkBAAIVI2RabMgf0-9DmAsBEr3aEFnRMPbNAAKpyTEbwCzQSrEyaGT_vCqfAQADAgADcwADLwQ",
      "AgACAgIAAxkBAAIVImRabMiu6BULf2BY_zFzyVMo6YFrAAKoyTEbwCzQSuuNmzs4MrKMAQADAgADcwADLwQ"
    ],

    group5: [
      "AgACAgIAAxkBAAIVJmRabS2I9wTkc6lTHqMmCbp60KnqAAKtyTEbwCzQStlFz8muI2FNAQADAgADcwADLwQ",
      "AgACAgIAAxkBAAIVKWRabS2Xp2iwZg8Lf5FuHAdT0P8GAAKvyTEbwCzQSh42bhW6QbTyAQADAgADcwADLwQ",
      "AgACAgIAAxkBAAIVKGRabS1OcI0qI43-NVWm1C7DAAGEHAACrMkxG8As0ErN7k08UlyvpgEAAwIAA3MAAy8E",
      "AgACAgIAAxkBAAIVJ2RabS0N0S7cwakc923LKviunquaAAKuyTEbwCzQSuGZGIEr2cF7AQADAgADcwADLwQ"
    ],

    group6: [
      "AgACAgIAAxkBAAKRZ2WB0tHtnxPXtGSE4mbIJgI8BQjfAAL61DEbaDYRSNOTNi4xjvUNAQADAgADeQADMwQ",
      "AgACAgIAAxkBAAKRZmWB0sncRBgE3n0srhIU5gm4OeOqAAL51DEbaDYRSD3Ex7bOTfgTAQADAgADeQADMwQ",
      "AgACAgIAAxkBAAKRZWWB0r6fpVYwuvjfWwhdFkJzr5BDAAL31DEbaDYRSBCfhz9J2ZpDAQADAgADeQADMwQ",
      "AgACAgIAAxkBAAKRZGWB0qd_Tn7D1kaFOfPd8wMGkhbhAAL21DEbaDYRSKZ8VPX0C-2yAQADAgADeQADMwQ"
    ],

    group7: [
      "AgACAgIAAxkBAAIufWSDQ6tsJYY_HFvqe-W8hLS2S8rcAALjyzEb-rkYSPqYZ0PVx3WXAQADAgADcwADLwQ",
      "AgACAgIAAxkBAAIufmSDQ7nsR9-RlZVnxTma7c6EBoCTAAK4zDEb9TkYSBkMfcbBjCtQAQADAgADcwADLwQ",
      "AgACAgIAAxkBAAIuf2SDQ76RRelS6HZzsmQFjm-ScHWFAAK5zDEb9TkYSJK1h6yD5MOYAQADAgADcwADLwQ",
      "AgACAgIAAxkBAAIugGSDQ8Naj9scbnJ1A8Cr1SClL3NbAAK6zDEb9TkYSGxfmNDwkoaWAQADAgADcwADLwQ"
    ]
  }

  def media_group(group, text) do
    [first_media | rest_media_group] = prepare_media(group)
    {:json, [Map.merge(first_media, %{parse_mode: "Markdown", caption: text})] ++ rest_media_group}
  end

  def prepare_media(group) do
    pics_ids = @groups[group]

    Enum.map(pics_ids, fn id ->
      %{type: "photo", media: id}
    end)
  end
end
