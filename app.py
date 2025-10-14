import flet as ft
import requests
from datetime import datetime

def main(page: ft.Page):
    page.title = "Aurora Tracker (FOSS)"
    page.theme_mode = ft.ThemeMode.DARK
    page.scroll = "auto"

    kp_text = ft.Text(value="Loading Kp index...", size=20)
    bz_text = ft.Text(value="Loading Bz data...", size=20)
    last_update = ft.Text(size=14, italic=True)

    def fetch_data(e=None):
        try:
            # Kp index
            kp_data = requests.get("https://services.swpc.noaa.gov/json/planetary_k_index_1m.json").json()
            current_kp = kp_data[-1]["Kp"]
            kp_time = kp_data[-1]["time_tag"]

            # Bz (IMF)
            bz_data = requests.get("https://services.swpc.noaa.gov/products/solar-wind/mag-1-day.json").json()
            bz_latest = float(bz_data[-1][2])

            kp_text.value = f"Current Kp Index: {current_kp}"
            bz_text.value = f"Current Bz: {bz_latest:.2f} nT"
            last_update.value = f"Last update: {kp_time}"

            # Simple alert
            if int(current_kp) >= 5 or bz_latest < -5:
                page.snack_bar = ft.SnackBar(ft.Text("Aurora possible tonight!"), open=True)
            else:
                page.snack_bar = ft.SnackBar(ft.Text("Low aurora activity."), open=True)

            page.update()

        except Exception as err:
            kp_text.value = f"Error: {err}"
            bz_text.value = ""
            page.update()

    refresh_btn = ft.ElevatedButton("Refresh Data", icon=ft.icons.REFRESH, on_click=fetch_data)

    page.add(
        ft.Column(
            [
                ft.Text("🌌 Aurora Tracker", size=30, weight="bold"),
                kp_text,
                bz_text,
                refresh_btn,
                last_update
            ],
            alignment=ft.MainAxisAlignment.START,
            spacing=15,
        )
    )

    fetch_data()  # initial load

ft.app(target=main)
