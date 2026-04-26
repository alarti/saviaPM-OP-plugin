import { Component, Input } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'ai-project-advisor',
  template: `
    <div class="ai-advisor-container">
      <button class="button -primary -with-icon icon-bulb" (click)="analyzeProject()" [disabled]="isLoading">
        {{ isLoading ? 'Analyzing...' : 'Project Advisor' }}
      </button>
      <div *ngIf="suggestions" class="ai-advisor-results">
        <h4>Optimization Suggestions:</h4>
        <ul>
          <li *ngFor="let suggestion of suggestions">{{ suggestion }}</li>
        </ul>
      </div>
      <div *ngIf="error" class="ai-advisor-error">
        {{ error }}
      </div>
    </div>
  `,
  styles: [`
    .ai-advisor-container {
      margin-top: 15px;
    }
    .ai-advisor-results {
      margin-top: 10px;
      padding: 10px;
      background-color: #f8f9fa;
      border: 1px solid #ddd;
      border-radius: 4px;
    }
    .ai-advisor-error {
      color: red;
      margin-top: 10px;
    }
  `]
})
export class ProjectAdvisorComponent {
  @Input() projectId!: string;

  isLoading = false;
  suggestions: string[] | null = null;
  error: string | null = null;

  constructor(private http: HttpClient) {}

  analyzeProject() {
    this.isLoading = true;
    this.error = null;
    this.suggestions = null;

    this.http.get<any>(`/projects/${this.projectId}/ai_project_planner/analysis`).subscribe({
      next: (response) => {
        this.suggestions = response.suggestions;
        this.isLoading = false;
      },
      error: (err) => {
        this.error = 'Failed to analyze project. Please try again.';
        this.isLoading = false;
        console.error(err);
      }
    });
  }
}
