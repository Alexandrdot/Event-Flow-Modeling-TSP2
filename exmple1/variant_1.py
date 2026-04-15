from PyQt6.QtWidgets import QApplication, QMainWindow, QMessageBox, QPushButton
import matplotlib.pyplot as plt
from PyQt6.uic import loadUi
import random
import math
import sys


class PoissonEventFlow(QMainWindow):
    def __init__(self):
        super().__init__()
        loadUi('form.ui', self)

        self.intensity = 0.333
        self.t_dir = 100

        self.run = self.findChild(QPushButton, 'run')
        self.run.clicked.disconnect()
        self.run.clicked.connect(self.on_run_clicked)

        self.doubleSpinBox.setValue(self.intensity)
        self.spinBox.setValue(self.t_dir)

        self.setWindowTitle("Генератор пуассоновского потока событий")

    def generate_event_moments(self, intensity, t_dir):
        res_data = {}
        time = 0
        count = 0

        while time <= t_dir:
            r = random.uniform(0, 1)
            time += (-1/intensity * math.log(r))
            count += 1
            if time <= t_dir:
                res_data[time] = count
        return res_data

    def on_run_clicked(self):
        self.intensity = self.doubleSpinBox.value()
        self.t_dir = self.spinBox.value()
        if self.intensity <= 0:
            QMessageBox.warning(self, "Ошибка", "Интенсивность должна быть больше 0")
            return

        if self.t_dir <= 0:
            QMessageBox.warning(self, "Ошибка", "Директивное время должно быть больше 0")
            return

        data = self.generate_event_moments(self.intensity, self.t_dir)
        self.create_chart(data)

    def create_chart(self, data):
        if not data:
            QMessageBox.warning(self, "Предупреждение", "Нет данных для построения графика")
            return

        times = list(data.keys())
        counts = list(data.values())

        plt.figure(figsize=(10, 6))
        plt.step(times, counts, where='post', linewidth=2, color='blue', label='Накопленное количество событий')

        plt.xlabel('Время', fontsize=12)
        plt.ylabel('Количество событий', fontsize=12)
        plt.title(f'Ступенчатый график накопления событий\n'
                  f'Интенсивность: {self.intensity}, Директивное время: {self.t_dir}',
                  fontsize=14)
        plt.grid(True, alpha=0.3)
        plt.legend(fontsize=10)

        total_events = counts[-1] if counts else 0
        plt.text(0.5, 0.98, f'Всего событий: {total_events}', 
                transform=plt.gca().transAxes, fontsize=10,
                verticalalignment='top',
                bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))
        
        plt.tight_layout()
        plt.show()


def main():
    app = QApplication(sys.argv)
    window = PoissonEventFlow()
    window.show()
    sys.exit(app.exec())


if __name__ == '__main__':
    main()
